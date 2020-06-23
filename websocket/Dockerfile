FROM golang:latest
RUN mkdir -p /go/src/main/
WORKDIR /go/src/main
COPY . .
RUN go get github.com/gorilla/websocket
RUN go install main
RUN ls

CMD /go/bin/main
