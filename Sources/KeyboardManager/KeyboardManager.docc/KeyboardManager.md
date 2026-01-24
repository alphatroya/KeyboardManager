# ``KeyboardManager``

Simple wrapper for UIKeyboard notification events that simplifies keyboard handling in iOS apps.

## Overview

The KeyboardManager framework provides a clean and modern way to handle keyboard notifications in iOS applications. It introduces a ``KeyboardObserver`` object with helper methods that simplify working with UIKeyboard notification data.

### Basic Usage

```swift
self.observationToken = KeyboardObserver.addObserver { event in
    if case let .willShow(data) = event {
        // process KeyboardManagerEvent.Data struct
    }
}
```

### Deprecation Notice

During WWDC 2021, Apple announced a [keyboard layout guide](https://developer.apple.com/videos/play/wwdc2021/10259/) that provides a more elegant and native way to handle keyboard avoidance. If you're targeting iOS 15 and above, consider using Apple's native keyboard layout guide API instead.

## Topics

### Getting Started

- <doc:GettingStarted>

### Observing Keyboard Events

- ``KeyboardObserver``
- ``KeyboardObserverToken``

### Keyboard Event Data

- ``KeyboardManagerEvent``
- ``KeyboardManagerEvent/Data``
- ``KeyboardManagerEvent/Frame``

### Event Closures

- ``KeyboardManagerEventClosure``

### Internal Components

- ``LastKeyboardEventStorage``