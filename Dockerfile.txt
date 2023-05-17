From golang:1.20.4-alpine3.17

WORKDIR /go/src/app

COPY . .

RUN go mod init vitalii.ua/server
RUN go mod tidy

RUN go build -o main main.go

CMD ["./main"]
