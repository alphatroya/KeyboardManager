all: bootstrap

## clean: clean build artifacts
clean:
	rm -rf .build

.PHONY: docs
## docs: Generate documentation
docs:
	swift-doc generate --module-name KeyboardManager -o docs --format html . --base-url 'https://alphatroya.github.io/Keyboaranager'
