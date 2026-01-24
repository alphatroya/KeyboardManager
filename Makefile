XCRUN := $(shell which xcrun)

all: bootstrap

## clean: clean build artifacts
clean:
	rm -rf .build

.PHONY: docs
## docs: Generate documentation
docs:
	xcodebuild docbuild -scheme KeyboardManager -destination 'platform=iOS Simulator,name=iPhone 17' -derivedDataPath .build
	$(XCRUN) docc process-archive transform-for-static-hosting .build/Build/Products/Debug-iphonesimulator/KeyboardManager.doccarchive --output-path docs --hosting-base-path KeyboardManager
