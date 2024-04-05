.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: grpcui
ALL_PROTOS = $(shell find ./pkg -name '*.proto')
grpcui: ## Start the gRPC UI; an interactive API playground
ifeq ($(shell which grpcui),)
	brew install grpcui
endif
	@grpcui -plaintext -import-path ./pkg -import-path ./third_party $(foreach var, $(ALL_PROTOS), -proto "$(var)") $(if $(host),$(host),"localhost:50051")
