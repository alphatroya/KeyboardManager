# Keyboard Manager
[![Swift 5.0+](https://img.shields.io/badge/Swift-5.0+-red.svg)]()
![Run tests](https://github.com/alphatroya/KeyboardManager/workflows/Run%20tests/badge.svg)
[![Documentation](https://img.shields.io/badge/Docs-available-yellow)](https://alphatroya.github.io/KeyboardManager)

Simple wrap up for UIKeyboardNotification events

## Deprecation notice

During wwdc2021 event apple announce a [keyboard layout guide](https://developer.apple.com/videos/play/wwdc2021/10259/). This new API does the same thing in a more elegant and native way.

If you target your app for iOS 15 and above, you better use this API for setup keyboard avoidance.

## Usage

The framework introduces a KeyboardObserver object with helper methods that simplify working with UIKeyboardNotification data.

``` swift
self.observationToken = KeyboardObserver.addObserver { event in
    if case let .willShow(data) = event {
        // process KeyboardManager.Data struct
    }
}
```

## Installation

### Swift Package Manager (required Xcode 11)

1. Select File > Swift Packages > Add Package Dependency. Enter `https://github.com/alphatroya/KeyboardManager` in the "Choose Package Repository" dialog.
2. In the next page, specify the version resolving rule as "Up to Next Major" with "1.4.0" as its earliest version.
3. After Xcode checking out the source and resolving the version, you can choose the "KeyboardManager" library and add it to your app target.

## Author

Alexey Korolev, alphatroya@gmail.com
Vlad Zaicev, zaycevvd95@gmail.com
