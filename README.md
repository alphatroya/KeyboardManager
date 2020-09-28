# Keyboard Manager
[![Swift 5.0+](https://img.shields.io/badge/Swift-5.0+-red.svg)]()
[![Build Status](https://travis-ci.org/alphatroya/KeyboardManager.svg?branch=master)](https://travis-ci.org/alphatroya/KeyboardManager)
[![codebeat badge](https://codebeat.co/badges/e4acc510-15c2-45ef-9aa3-47d475ab3275)](https://codebeat.co/projects/github-com-alphatroya-keyboardmanager)
[![codecov](https://codecov.io/gh/alphatroya/KeyboardManager/branch/master/graph/badge.svg)](https://codecov.io/gh/alphatroya/KeyboardManager)
[![Documentation](docs/badge.svg)](https://alphatroya.github.io/KeyboardManager)

Simple wrap up for UIKeyboardNotification events

## Usage

The framework introduce a KeyboardManager class with `eventClosure` property what receive parsed UIKeyboardNotification user data values

``` swift
let keyboardManager = KeyboardManager(notificationCenter: NotificationCenter.default)
keyboardManager.eventClosure = { event in
    if case let .willShow(data) = event {
        // process KeyboardManager.Data struct
    }
}
```

There is also a helper method `bindToKeyboardNotifications(scrollView: UIScrollView)` which simplify inset adjustment after keyboard appear/disappear 

## Installation
 
### Swift Package Manager (required Xcode 11)

1. Select File > Swift Packages > Add Package Dependency. Enter `https://github.com/alphatroya/KeyboardManager` in the "Choose Package Repository" dialog.
2. In the next page, specify the version resolving rule as "Up to Next Major" with "1.4.0" as its earliest version.
3. After Xcode checking out the source and resolving the version, you can choose the "KeyboardManager" library and add it to your app target.

## Author

Alexey Korolev, alphatroya@gmail.com
