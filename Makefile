.PHONY: lint format

# Lint all markdown files in the repository
lint:
	@echo "Linting Markdown files..."
	npx markdownlint-cli "**/*.md"

# Automatically fix markdown lint errors
format:
	@echo "Formatting Markdown files..."
	npx markdownlint-cli --fix "**/*.md"
