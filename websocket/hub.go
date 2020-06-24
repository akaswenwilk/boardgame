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

func (hub *Hub) Delete() error {
	err = fmt.Errorf("not enough space for a new hub")
	var emptyHub *Hub

	for i, h := range Hubs {
		if h != emptyHub && h.GameID == hub.GameID {
			Hubs[i] = emptyHub
			err = nil
			break
		}
	}

	return err
}

func (hub *Hub) AddClient(client *Client) error {
	err = fmt.Errorf("too many clients in this hub")
	for i, c := range hub.Clients {
		if c == nil {
			hub.Clients[i] = client
			err = nil
			break
		}
	}

	return err
}
