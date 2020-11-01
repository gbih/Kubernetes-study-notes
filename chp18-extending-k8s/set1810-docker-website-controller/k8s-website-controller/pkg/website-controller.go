package main

import (
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"net/http"
	"strings"
)

//--------------

type Metadata struct {
	Name      string
	Namespace string
}

type WebsiteSpec struct {
	GitRepo string
  ServiceAccount string
  ServiceAccountName string
}

type Website struct {
	Metadata Metadata
	Spec     WebsiteSpec
}

type WebsiteWatchEvent struct {
	Type   string
	Object Website
}

//---------------

func main() {
	log.Println("website-controller started.")

	for {
		resp, err := http.Get("http://localhost:8001/apis/extensions.example.com/v1/websites?watch=true")
		if err != nil {
			panic(err)
		}
		defer resp.Body.Close()

		decoder := json.NewDecoder(resp.Body)
		for {
			var event WebsiteWatchEvent
			if err := decoder.Decode(&event); err == io.EOF {
				break
			} else if err != nil {
				log.Fatal(err)
			}

			// log.Printf("Received watch event: Type: %s, Name: %s, GitRepo: %s\n", event.Type, event.Object.Metadata.Name,  event.Object.Spec.GitRepo)

			log.Printf("Debug: event object: %#v\n", event)

			if event.Type == "ADDED" {
				createWebsite(event.Object)
			} else if event.Type == "DELETED" {
				deleteWebsite(event.Object)
			}
		}
	}

}

func createWebsite(website Website) {
	createResource(website, "api/v1", "services", "service-template.json")
	createResource(website, "apis/apps/v1", "deployments", "deployment-template.json")
}

func deleteWebsite(website Website) {
	deleteResource(website, "api/v1", "services", getName(website))
	deleteResource(website, "apis/apps/v1", "deployments", getName(website))
}

func createResource(webserver Website, apiGroup string, kind string, filename string) {

	log.Printf("Namespace: %s", webserver.Metadata.Namespace)

	log.Printf("Creating %s with name %s in namespace %s", kind, getName(webserver), webserver.Metadata.Namespace)
	templateBytes, err := ioutil.ReadFile(filename)
	if err != nil {
		log.Fatal(err)
	}
	template := strings.Replace(string(templateBytes), "[NAME]", getName(webserver), -1)
	template = strings.Replace(template, "[GIT-REPO]", webserver.Spec.GitRepo, -1)
	template = strings.Replace(template, "[SERVICE-ACCOUNT]", webserver.Spec.ServiceAccount, -1)
	template = strings.Replace(template, "[SERVICE-ACCOUNT-NAME]", webserver.Spec.ServiceAccountName, -1)

	template = strings.Replace(template, "[NAMESPACE]", webserver.Metadata.Namespace, -1)



	query := (fmt.Sprintf("http://localhost:8001/%s/namespaces/%s/%s/", apiGroup, webserver.Metadata.Namespace, kind))
	log.Println("query: ", query)

	// for debugging
	queryPost := fmt.Sprint(query, "application/json", strings.NewReader(template))
	log.Println("queryPost: ", queryPost)

	resp, err := http.Post(query, "application/json", strings.NewReader(template))

	// resp, err := http.Post(fmt.Sprintf("http://localhost:8001/%s/namespaces/%s/%s/", apiGroup, webserver.Metadata.Namespace, kind), "application/json", strings.NewReader(template))
	if err != nil {
		fmt.Println("ERROR in createResource()")
		log.Fatal(err)
	}
	log.Println("response Status:", resp.Status)
}

func deleteResource(webserver Website, apiGroup string, kind string, name string) {
	log.Printf("Deleting %s with name %s in namespace %s", kind, name, webserver.Metadata.Namespace)
	req, err := http.NewRequest(http.MethodDelete, fmt.Sprintf("http://localhost:8001/%s/namespaces/%s/%s/%s", apiGroup, webserver.Metadata.Namespace, kind, name), nil)
	if err != nil {
		log.Fatal(err)
		return
	}
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		log.Fatal(err)
		return
	}
	log.Println("response Status:", resp.Status)

}

func getName(website Website) string {
	return website.Metadata.Name + "-website"
}
