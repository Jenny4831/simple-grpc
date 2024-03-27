.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: proto
PROTO_FILES=$(shell find ./$(SRC_DIR) -name '*.proto' ! -name 'health.proto')
THIRD_PARTY=pkg/third_party/
DB_GEN_DIR=internal/gendb
SRC_DIR=pkg/
PROTOC_GO_VERSION=3.11.3
PROTOC_VERSION=1.12.0

OUT_DIR=pkg/simplegrpc
GO_OUT_DIR=$(OUT_DIR)/go

proto: go mocks ## Generate go code, mocks and update docs

ifneq ($(shell which getent),)
UID = $(shell getent passwd buildkite-agent | cut -d ':' -f 3)
endif
ifeq ($(shell echo $(UID)),)
UID = root
endif

output_dir:
	@mkdir -p $(GO_OUT_DIR)

go: output_dir ## Generates all the Golang source files
	@rm -rf $(GO_OUT_DIR)/*
	echo "Generating Go code for $(SRC_DIR) ...";

	# generate go code and docs
	@docker run \
        -v $(PWD):/$(SRC_DIR) \
        namely/protoc-all -f *.proto -l go

.PHONY: grpcui
ALL_PROTOS = $(shell find ./pkg -name '*.proto')
grpcui: ## Start the gRPC UI; an interactive API playground
ifeq ($(shell which grpcui),)
	GO111MODULE=off go get -u github.com/fullstorydev/grpcui/cmd/grpcui
endif
	@grpcui -import-path ./protos -import-path ./third_party $(foreach var, $(ALL_PROTOS), -proto "$(var)") $(if $(host),$(host),"localhost:50051")

### Mock generator
.PHONY: mocks
mocks: ## Generate the mocks for the .proto files
	@echo "Generating mocks for $(SRC_DIR) ...";
	@go run github.com/vektra/mockery/v2@latest \
		--dir=$(OUT_DIR) \
		--all \
		--case=underscore \
		--output=$(OUT_DIR)/mock \
		--outpkg=simplegrpcmock