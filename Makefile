# AtchisonWebsites — project control Makefile
# Run `make` or `make help` to see the list of available targets.

.DEFAULT_GOAL := help

.PHONY: help clean dev ports test

help: ## Show this list of available targets
	@grep -E '^[a-zA-Z0-9/_-]+:.*##' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*##"}; {printf "  %-15s %s\n", $$1, $$2}'

clean: ## Remove stray .DS_Store files from the repo
	find . -name '.DS_Store' -type f -delete

dev: ## Run all websites on their worktree-derived ports
	@foreman start

ports: ## Show the dev ports this checkout (main or worktree) will use
	@bin/site-port --all

test: ## Run the worktree port-derivation unit test
	ruby test/worktree_env_test.rb
