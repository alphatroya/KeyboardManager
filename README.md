# Keyboard Manager
[![Swift 3.0+](https://img.shields.io/badge/Swift-3.0+-red.svg)]() [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![Build Status](https://travis-ci.org/alphatroya/KeyboardManager.svg?branch=master)](https://travis-ci.org/alphatroya/KeyboardManager) [![codebeat badge](https://codebeat.co/badges/e4acc510-15c2-45ef-9aa3-47d475ab3275)](https://codebeat.co/projects/github-com-alphatroya-keyboardmanager) [![codecov](https://codecov.io/gh/alphatroya/KeyboardManager/branch/master/graph/badge.svg)](https://codecov.io/gh/alphatroya/KeyboardManager) 

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
### Carthage
To integrate KeyboardManager into your Xcode project using Carthage, specify it in your Cartfile:

```ogdl
github "alphatroya/KeyboardManager"
```

Run `carthage update` to build the framework and drag the built KeyboardManager.framework into your Xcode project.

## TODO
- [X] Complete README.md description
- [ ] Write documentation for public methods 

## Author
Alexey Korolev, alphatroya@gmail.com
