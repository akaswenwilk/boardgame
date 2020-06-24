package main

import (
	"github.com/gorilla/websocket"
)

type Client struct {
	Connection *websocket.Conn
	ID         string
	GameID     string
}

func NewClient(c *websocket.Conn, id, gameId string) *Client {
	return &Client{
		Connection: c,
		ID:         id,
		GameID:     gameId,
	}
}
