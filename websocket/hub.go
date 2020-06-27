package main

import (
	"fmt"
	"log"
)

var hubNumber int = 0

type Hub struct {
	ID      int
	Clients [4]*Client
	GameID  string
}

var Hubs [30]*Hub
var err error

func FindHubByGameID(id string) *Hub {
	var hub *Hub
	for _, h := range Hubs {
		if h != hub {
			if h.GameID == id {
				log.Printf("match with hub: %v", h)
				hub = h
				break
			}
		}
	}

	return hub
}

func NewHub(id string) *Hub {
	hubNumber += 1

	return &Hub{
		ID:     hubNumber,
		GameID: id,
	}
}

func CreateHub(id string) (*Hub, error) {
	var hub *Hub
	err = fmt.Errorf("not enough space for a new hub")
	for i, h := range Hubs {
		if h == nil {
			err = nil
			hub = NewHub(id)
			Hubs[i] = hub
			break
		}
	}

	return hub, err
}

func FindOrCreateHubByGameId(id string) (*Hub, error) {
	h := FindHubByGameID(id)
	if h != nil {
		log.Printf("find or create has found %v", h)
		return h, nil
	} else {
		h, err = CreateHub(id)
		return h, err
	}
}

func (hub *Hub) Delete() {
	var emptyHub *Hub

	clientsAreEmpty := true

	for _, c := range hub.Clients {
		if c != nil {
			clientsAreEmpty = false
		}
	}

	if clientsAreEmpty {
		for i, h := range Hubs {
			if h != emptyHub && h.GameID == hub.GameID {
				Hubs[i] = emptyHub
				break
			}
		}
	}
}

func (hub *Hub) DeleteClient(userId string) {
	var emptyClient *Client
	for i, c := range hub.Clients {
		if c.userId == userId {
			hub.Clients[i] = emptyClient
			break
		}
	}
}

func (hub *Hub) AddOrReplaceClient(client *Client) error {
	err = fmt.Errorf("too many clients in this hub")
	for i, c := range hub.Clients {
		if c == nil || c.userId == client.userId {
			hub.Clients[i] = client
			err = nil
			break
		}
	}

	return err
}
