package main

import (
	"context"
	"log"
	"net"

	pb "github.com/Jenny4831/simple-grpc/pkg/pb-go/simple-grpc"

	"google.golang.org/grpc"
)

type server struct{}

func (s *server) SayHello(ctx context.Context, req *pb.HelloRequest) (*pb.HelloResponse, error) {
	// TODO: Implement the SayHello method
	// return message with "Hello, <name in request>"
	return &pb.HelloResponse{Message: "Hello, " + req.Name}, nil
	// Homework 2
	// extract items from metadata in context

	// return nil, nil
}

func main() {
	lis, err := net.Listen("tcp", ":50051")
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	s := grpc.NewServer()
	pb.RegisterGreeterServer(s, &server{})

	log.Println("Server listening on port 50051")
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
