package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

var requestCount int = 0

func handler(w http.ResponseWriter, r *http.Request) {
	name, err := os.Hostname()
	if err != nil {
		log.Fatal(err)
	}

	requestCount++
	if requestCount > 5 {
		w.WriteHeader(http.StatusInternalServerError) // 500 status
		fmt.Fprintf(w, "Some internal error has occurred! This is pod is %v\n", name)
		return
	}

	fmt.Println("Received request from:", r.RemoteAddr)
	w.WriteHeader(http.StatusOK) // 200 status
	fmt.Fprintf(w, "This is v3 running in pod %v\n", name)
}

func main() {
	http.HandleFunc("/", handler)
	fmt.Println("Kubia server starting...")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
