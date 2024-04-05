package main

import (
	"context"
	"reflect"
	"testing"

	pb "github.com/Jenny4831/simple-grpc/pkg/pb-go/simple-grpc"
)

func Test_server_SayHello(t *testing.T) {
	type args struct {
		ctx context.Context
		req *pb.HelloRequest
	}
	tests := []struct {
		name    string
		s       *server
		args    args
		want    *pb.HelloResponse
		wantErr bool
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			s := &server{}
			got, err := s.SayHello(tt.args.ctx, tt.args.req)
			if (err != nil) != tt.wantErr {
				t.Errorf("server.SayHello() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("server.SayHello() = %v, want %v", got, tt.want)
			}
		})
	}
}
