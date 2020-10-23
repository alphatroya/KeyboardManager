all: bootstrap

## clean: clean build artifacts
clean:
	rm -rf .build

## bootstrap: Bootstrap project dependencies for development
bootstrap: hook
	mint bootstrap

## project: Generate xcproject file
project:
	swift package generate-xcodeproj

## test: Launch unit tests
test:
	bundle install
	bundle exec fastlane test

## fmt: Launch swift files code formatter
fmt:
	mint run swiftformat swiftformat Sources Tests

## hook: Install git pre-commit hook
hook:
	curl "https://gist.githubusercontent.com/alphatroya/884aef2590d3c873d4f0d447d6a95a3c/raw/8a2682772cf9a7625b680771cf9ad9106c6cf00e/pre-commit" > .git/hooks/pre-commit
	chmod +x .git/hooks/pre-commit

## help: Prints help message
help:
	@echo "Usage: \n"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'

.PHONY: docs
## docs: Generate documentation
docs:
	swift-doc generate --module-name KeyboardManager -o docs --format html . --base-url 'https://alphatroya.github.io/KeyboardManager'


.PHONY: clean help bootstrap test fmt hook
