# Environment variables with defaults
NODE_ENV ?= development
PORT ?= 3000

# Default target shows help
.DEFAULT_GOAL := help

.PHONY: help setup-project install db-setup post-setup clean

help: ## Show this help message
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

setup-project: install db-setup post-setup ## Complete project setup (install + db-setup) - WARNING: deletes all data
	@echo "✓ Project setup complete!"

install: ## Install dependencies and generate Prisma client
	@echo "Installing dependencies..."
	pnpm install

db-setup: ## Setup database with shadow db, prisma user, and run migrations - WARNING: deletes all data
	supabase db reset && ./setup-shadow-db.sh && ./setup-prisma-user.sh && pnpm db:generate
	@echo "✓ Database setup complete!"

post-setup: ## Run post-setup; removes temporary file created during setup
	rm supabase_auth.sql
	@echo "✓ Temporary files cleaned up"

clean: ## Clean node_modules and build artifacts
	rm -rf node_modules
	rm -rf .next
	rm -rf dist
	@echo "✓ Cleaned up build artifacts"
