# Keyboard Manager
[![Swift 5.0+](https://img.shields.io/badge/Swift-5.0+-red.svg)]()
![Run tests](https://github.com/alphatroya/KeyboardManager/workflows/Run%20tests/badge.svg)
[![codebeat badge](https://codebeat.co/badges/e4acc510-15c2-45ef-9aa3-47d475ab3275)](https://codebeat.co/projects/github-com-alphatroya-keyboardmanager)
[![Documentation](https://img.shields.io/badge/Docs-available-yellow)](https://alphatroya.github.io/KeyboardManager)

Simple wrap up for UIKeyboardNotification events

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
