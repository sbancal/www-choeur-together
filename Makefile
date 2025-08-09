# Jekyll Container Management Makefile
# Supports both Docker and Podman

# Configuration
IMAGE_NAME := www-choeur-together
CONTAINER_NAME := www-choeur-together
PORT := 4000

# Detect container runtime (Docker or Podman)
CONTAINER_RUNTIME := $(shell command -v podman 2>/dev/null || command -v docker 2>/dev/null)

# Colors for output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
NC := \033[0m

# Check if container runtime is available
ifndef CONTAINER_RUNTIME
$(error Neither Docker nor Podman found. Please install one of them to use this Jekyll setup)
endif

# Default target
.PHONY: help
help: ## Show this help message
	@echo "Jekyll Container Management"
	@echo ""
	@echo "Available targets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "Container Runtime: $(CONTAINER_RUNTIME)"
	@echo "Image Name: $(IMAGE_NAME)"
	@echo "Container Name: $(CONTAINER_NAME)"
	@echo "Port: $(PORT)"
	@echo ""
	@echo "Site will be available at: http://localhost:$(PORT)"

.PHONY: build
build: ## Build the Jekyll container image
	@echo -e "$(GREEN)[INFO]$(NC) Building Jekyll container image..."
	$(CONTAINER_RUNTIME) build -t $(IMAGE_NAME) .
	@echo -e "$(GREEN)[INFO]$(NC) Build completed successfully!"

.PHONY: run
run: stop ## Run the Jekyll development server in a container
	@echo -e "$(GREEN)[INFO]$(NC) Starting Jekyll development server..."
ifeq ($(shell basename $(CONTAINER_RUNTIME)),podman)
	$(CONTAINER_RUNTIME) run -d \
		--name $(CONTAINER_NAME) \
		-p $(PORT):4000 \
		-v "$$(pwd):/app:Z" \
		$(IMAGE_NAME)
else
	$(CONTAINER_RUNTIME) run -d \
		--name $(CONTAINER_NAME) \
		-p $(PORT):4000 \
		-v "$$(pwd):/app" \
		$(IMAGE_NAME)
endif
	@echo -e "$(GREEN)[INFO]$(NC) Jekyll server is starting..."
	@echo -e "$(GREEN)[INFO]$(NC) Site will be available at: http://localhost:$(PORT)"
	@echo -e "$(GREEN)[INFO]$(NC) Container name: $(CONTAINER_NAME)"
	@echo -e "$(YELLOW)[INFO]$(NC) Waiting for Jekyll server to be ready..."
	@sleep 1
	@echo -e "$(GREEN)[INFO]$(NC) Jekyll server should now be ready! Check logs with: make logs"

.PHONY: stop
stop: ## Stop and remove the Jekyll container
	@echo -e "$(GREEN)[INFO]$(NC) Stopping Jekyll container..."
	@$(CONTAINER_RUNTIME) stop $(CONTAINER_NAME) >/dev/null 2>&1 || true
	@$(CONTAINER_RUNTIME) rm $(CONTAINER_NAME) >/dev/null 2>&1 || true
	@echo -e "$(GREEN)[INFO]$(NC) Container stopped."

.PHONY: restart
restart: stop run ## Restart the Jekyll container

.PHONY: logs
logs: ## Show container logs (follow mode)
	@echo -e "$(GREEN)[INFO]$(NC) Showing Jekyll container logs..."
	$(CONTAINER_RUNTIME) logs -f $(CONTAINER_NAME)

.PHONY: shell
shell: ## Open a shell in the running container
	@echo -e "$(GREEN)[INFO]$(NC) Opening shell in Jekyll container..."
	$(CONTAINER_RUNTIME) exec -it $(CONTAINER_NAME) /bin/sh

.PHONY: status
status: ## Show container status
	@echo -e "$(GREEN)[INFO]$(NC) Container status:"
	@$(CONTAINER_RUNTIME) ps -a --filter name=$(CONTAINER_NAME) --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

.PHONY: clean
clean: stop ## Stop container and remove image
	@echo -e "$(GREEN)[INFO]$(NC) Removing Jekyll container image..."
	@$(CONTAINER_RUNTIME) rmi $(IMAGE_NAME) >/dev/null 2>&1 || true
	@echo -e "$(GREEN)[INFO]$(NC) Cleanup completed."

.PHONY: dev
dev: build run ## Build and run in one command (development workflow)
	@echo -e "$(GREEN)[INFO]$(NC) Development environment is ready!"

.PHONY: build-site
build-site: ## Build the Jekyll site (output to _site directory)
	@echo -e "$(GREEN)[INFO]$(NC) Building Jekyll site..."
ifeq ($(shell basename $(CONTAINER_RUNTIME)),podman)
	$(CONTAINER_RUNTIME) run --rm -v "$$(pwd):/app:Z" -w /app $(IMAGE_NAME) bundle exec jekyll build
else
	$(CONTAINER_RUNTIME) run --rm -v "$$(pwd):/app" -w /app $(IMAGE_NAME) bundle exec jekyll build
endif
	@echo -e "$(GREEN)[INFO]$(NC) Site built successfully in _site directory!"

.PHONY: bundle
bundle: ## Run bundle command in container (e.g., make bundle ARGS="add jekyll-sitemap")
	@echo -e "$(GREEN)[INFO]$(NC) Running bundle command in container..."
ifeq ($(shell basename $(CONTAINER_RUNTIME)),podman)
	$(CONTAINER_RUNTIME) run --rm -it -v "$$(pwd):/app:Z" -w /app $(IMAGE_NAME) bundle $(ARGS)
else
	$(CONTAINER_RUNTIME) run --rm -it -v "$$(pwd):/app" -w /app $(IMAGE_NAME) bundle $(ARGS)
endif

.PHONY: jekyll
jekyll: ## Run Jekyll command in container (e.g., make jekyll ARGS="new post 'My Post'")
	@echo -e "$(GREEN)[INFO]$(NC) Running Jekyll command in container..."
ifeq ($(shell basename $(CONTAINER_RUNTIME)),podman)
	$(CONTAINER_RUNTIME) run --rm -it -v "$$(pwd):/app:Z" -w /app $(IMAGE_NAME) bundle exec jekyll $(ARGS)
else
	$(CONTAINER_RUNTIME) run --rm -it -v "$$(pwd):/app" -w /app $(IMAGE_NAME) bundle exec jekyll $(ARGS)
endif

# Quick commands
.PHONY: up down serve
up: run ## Alias for 'run'
down: stop ## Alias for 'stop'
serve: run ## Alias for 'run' (common Jekyll command)
