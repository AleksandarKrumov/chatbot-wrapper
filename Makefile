.PHONY: help setup install update-deps sync test lint format type-check clean dev build docker-build docker-run

# Default target
.DEFAULT_GOAL := help

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

setup: ## Initial project setup
	@echo "Setting up development environment..."
	uv venv --python 3.12
	uv pip install -e ".[dev,test]"
	@echo "Setup complete!"

install: ## Install dependencies
	uv pip install -e ".[dev,test]"

update-deps: ## Update and sync dependencies
	@echo "Updating dependencies..."
	uv lock --upgrade
	uv sync

sync: ## Sync environment with lockfile
	uv sync

test: ## Run tests
	uv run pytest tests/ -v --cov=src --cov-report=term-missing --cov-report=html

test-watch: ## Run tests in watch mode
	uv run pytest-watch tests/

lint: ## Run linting
	uv run ruff check src tests
	uv run ruff format --check src tests

format: ## Format code
	uv run ruff format src tests
	uv run ruff check --fix src tests

type-check: ## Run type checking
	uv run mypy src

quality: lint type-check ## Run all quality checks

ci: quality test ## Run CI pipeline locally

clean: ## Clean cache and build artifacts
	rm -rf .pytest_cache
	rm -rf .mypy_cache
	rm -rf .ruff_cache
	rm -rf htmlcov
	rm -rf dist
	rm -rf build
	rm -rf *.egg-info
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete

dev: ## Start development server
	uv run python -m src.my_project.main

build: ## Build package
	uv build

docker-build: ## Build Docker image
	docker-compose -f .devcontainer/docker-compose.yml build

docker-run: ## Run with Docker Compose
	docker-compose -f .devcontainer/docker-compose.yml up -d

docker-down: ## Stop Docker Compose
	docker-compose -f .devcontainer/docker-compose.yml down

shell: ## Open interactive shell in container
	docker-compose -f .devcontainer/docker-compose.yml exec devcontainer /bin/bash

logs: ## Show container logs
	docker-compose -f .devcontainer/docker-compose.yml logs -f devcontainer

# Development commands
jupyter: ## Start Jupyter Lab
	uv run jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root

docs-serve: ## Serve documentation locally
	uv run mkdocs serve

pre-commit: ## Run pre-commit hooks
	uv run pre-commit run --all-files
