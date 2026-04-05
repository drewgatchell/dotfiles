.PHONY: help install update lint

.DEFAULT_GOAL := help

help: ## Show available targets
	@echo "Dotfiles Management"
	@echo "==================="
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  make %-12s %s\n", $$1, $$2}'
	@echo ""
	@echo "Examples:"
	@echo "  make install TAGS=shell,git   Run only specific roles"

install: ## Run Ansible playbook (use TAGS= for specific roles)
	@cd ansible && \
	if [ -n "$(TAGS)" ]; then \
		ansible-playbook site.yml --tags "$(TAGS)"; \
	else \
		ansible-playbook site.yml; \
	fi

update: ## Pull latest changes and run playbook
	git pull
	@$(MAKE) install

lint: ## Lint Ansible playbook
	cd ansible && ansible-lint site.yml
