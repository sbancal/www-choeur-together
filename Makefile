# Jekyll Container Management Makefile (Dual Targets)

# Configuration
IMAGE_NAME := www-choeur-together
CONTAINER_NAME := www-choeur-together
PORT_MAIN := 4000
PORT_NEXT := 4001

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

.DEFAULT_GOAL := help

.PHONY: help dev-main dev-next stop-main stop-next logs-main logs-next build

help: ## Show this help message
	@echo "Jekyll Container Management"
	@echo ""
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  $(GREEN)%-16s$(NC) %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "Container Runtime: $(CONTAINER_RUNTIME)"
	@echo "Image Name: $(IMAGE_NAME)"
	@echo ""

dev-main: stop-main ## Run main site container on port 4000
	@echo -e "$(GREEN)[INFO]$(NC) Starting main site on :$(PORT_MAIN)..."
ifeq ($(shell basename $(CONTAINER_RUNTIME)),podman)
	$(CONTAINER_RUNTIME) run -d \
		--name $(CONTAINER_NAME) \
		-p $(PORT_MAIN):4000 \
		-v "$$(pwd):/app:Z" \
		$(IMAGE_NAME)
else
	$(CONTAINER_RUNTIME) run -d \
		--name $(CONTAINER_NAME) \
		-p $(PORT_MAIN):4000 \
		-v "$$(pwd):/app" \
		$(IMAGE_NAME)
endif
	@echo -e "$(GREEN)[INFO]$(NC) Main site running at: http://localhost:$(PORT_MAIN)"

dev-next: stop-next ## Run next site container on port 4001
	@echo -e "$(GREEN)[INFO]$(NC) Starting next site on :$(PORT_NEXT)..."
ifeq ($(shell basename $(CONTAINER_RUNTIME)),podman)
	$(CONTAINER_RUNTIME) run -d \
		--name $(CONTAINER_NAME)-next \
		-p $(PORT_NEXT):4000 \
		-v "$$(pwd)/next:/app:Z" \
		$(IMAGE_NAME)
else
	$(CONTAINER_RUNTIME) run -d \
		--name $(CONTAINER_NAME)-next \
		-p $(PORT_NEXT):4000 \
		-v "$$(pwd)/next:/app" \
		$(IMAGE_NAME)
endif
	@echo -e "$(GREEN)[INFO]$(NC) Next site running at: http://localhost:$(PORT_NEXT)"

stop-main: ## Stop and remove main site container
	@echo -e "$(GREEN)[INFO]$(NC) Stopping main site container..."
	@$(CONTAINER_RUNTIME) stop $(CONTAINER_NAME) >/dev/null 2>&1 || true
	@$(CONTAINER_RUNTIME) rm $(CONTAINER_NAME) >/dev/null 2>&1 || true

stop-next: ## Stop and remove next site container
	@echo -e "$(GREEN)[INFO]$(NC) Stopping next site container..."
	@$(CONTAINER_RUNTIME) stop $(CONTAINER_NAME)-next >/dev/null 2>&1 || true
	@$(CONTAINER_RUNTIME) rm $(CONTAINER_NAME)-next >/dev/null 2>&1 || true

logs-main: ## Show logs for main site container
	@echo -e "$(GREEN)[INFO]$(NC) Showing main site logs..."
	$(CONTAINER_RUNTIME) logs -f $(CONTAINER_NAME)

logs-next: ## Show logs for next site container
	@echo -e "$(GREEN)[INFO]$(NC) Showing next site logs..."
	$(CONTAINER_RUNTIME) logs -f $(CONTAINER_NAME)-next

build-main: ## Build the main Jekyll site
	@echo -e "$(GREEN)[INFO]$(NC) Building main Jekyll site..."
ifeq ($(shell basename $(CONTAINER_RUNTIME)),podman)
	$(CONTAINER_RUNTIME) run --rm -v "$$(pwd):/app:Z" -w /app $(IMAGE_NAME) bundle exec jekyll build
else
	$(CONTAINER_RUNTIME) run --rm -v "$$(pwd):/app" -w /app $(IMAGE_NAME) bundle exec jekyll build
endif
	@echo -e "$(GREEN)[INFO]$(NC) Main site built successfully in _site directory!"

build-next: ## Build the next Jekyll site
	@echo -e "$(GREEN)[INFO]$(NC) Building next Jekyll site..."
ifeq ($(shell basename $(CONTAINER_RUNTIME)),podman)
	$(CONTAINER_RUNTIME) run --rm -v "$$(pwd)/next:/app:Z" -w /app $(IMAGE_NAME) bundle exec jekyll build --destination ../_site_next
else
	$(CONTAINER_RUNTIME) run --rm -v "$$(pwd)/next:/app" -w /app $(IMAGE_NAME) bundle exec jekyll build --destination ../_site_next
endif
	@echo -e "$(GREEN)[INFO]$(NC) Next site built successfully in _site_next directory!"
