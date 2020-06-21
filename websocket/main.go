// websockets.go
package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

func check(err error) {
	if err != nil {
		log.Println(err)
		panic(err)
	}
}

func handler(w http.ResponseWriter, r *http.Request) {
	conn, err := upgrader.Upgrade(w, r, nil)
	check(err)
	fmt.Println(conn)
	for {
		// Read message from browser
		msgType, msg, err := conn.ReadMessage()
		check(err)

		// Print the message to the console
		fmt.Printf("%s sent: %s\n", conn.RemoteAddr(), string(msg))

		// Write message back to browser
		if err = conn.WriteMessage(msgType, msg); err != nil {
			return
		}
	}
}

func main() {
	http.HandleFunc("/", handler)

	http.ListenAndServe(":8080", nil)
}
