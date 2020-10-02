package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

func handler(w http.ResponseWriter, r *http.Request) {
	name, err := os.Hostname()
	if err != nil {
		log.Fatal(err)
	}
  fmt.Println("Received request from:", r.RemoteAddr)
  w.WriteHeader(http.StatusOK) // 200 status
  fmt.Fprintf(w, "This is v4 running in pod %v\n", name)
}

func main() {
	http.HandleFunc("/", handler)
	fmt.Println("Kubia server starting...")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
