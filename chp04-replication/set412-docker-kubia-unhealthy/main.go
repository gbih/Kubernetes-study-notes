package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

var requestCount int = 0

func handler(w http.ResponseWriter, r *http.Request) {
  fmt.Println("Received request from:", r.RemoteAddr)	

  name, err := os.Hostname()
  if err != nil {
    log.Fatal(err)
  }

	requestCount++
	if requestCount > 5 {
		w.WriteHeader(http.StatusInternalServerError) // 500 status
		w.Write([]byte("I'm not well. Please restart me!\n"))
		return
	}

	w.WriteHeader(http.StatusOK) // 200 status
	fmt.Fprintf(w, "You've hit %v\n", name)
}

func main() {
	http.HandleFunc("/", handler)
	fmt.Println("Kubia server starting...")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
