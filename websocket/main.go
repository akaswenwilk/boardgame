// websockets.go
package main

import (
	"fmt"
	"log"
	"net/http"
	"strings"

	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
	CheckOrigin: func(r *http.Request) bool {
		//fmt.Println(r)
		return true
	},
}

func parseUrl(url string) (string, string, error) {
	paths := strings.Split(url, "/")
	if len(paths) != 5 || paths[1] != "games" || paths[3] != "users" {
		err := fmt.Errorf("invalid URL for %v", url)
		return "", "", err
	} else {
		fmt.Println("valid url")
		return paths[2], paths[4], nil
	}
}

func Handler(w http.ResponseWriter, r *http.Request) {
	gameId, userId, err := parseUrl(r.URL.Path)
	if err != nil {
		log.Println(err)
		return
	}
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println(err)
		return
	}
	defer conn.Close()

	hub, err := FindOrCreateHubByGameId(gameId)
	if err != nil {
		log.Println(err)
		return
	}
	defer hub.Delete()

	client := NewClient(conn, userId, gameId)
	err = hub.AddClient(client)
	log.Printf("adding client to Hub with ID: %v", hub.ID)
	if err != nil {
		log.Println(err)
		return
	}

	fmt.Println(Hubs)

	for {
		_, msg, err := client.Connection.ReadMessage()
		if err != nil {
			if websocket.IsUnexpectedCloseError(err, websocket.CloseGoingAway, websocket.CloseAbnormalClosure) {
				log.Printf("error: %v", err)
			}
			break
		}
		log.Println(hub.Clients)
		for _, c := range hub.Clients {
			if c == nil || c.ID == client.ID {
				continue
			}

			log.Printf("writing to client with ID %v", c.ID)
			c.Connection.WriteMessage(websocket.TextMessage, msg)
		}
	}
}

func main() {
	http.HandleFunc("/games/", Handler)

	http.ListenAndServe(":8080", nil)
}
