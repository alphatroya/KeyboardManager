# Getting Started with KeyboardManager

Learn how to integrate KeyboardManager into your iOS app to handle keyboard notifications efficiently.

## Overview

KeyboardManager provides three primary ways to observe keyboard events:

1. **Event-based observation** - Listen to specific keyboard events
2. **Constraint-based observation** - Automatically adjust view constraints
3. **ScrollView observation** - Automatically adjust scroll view insets

## Basic Event Observation

The most flexible approach is to observe keyboard events directly:

```swift
import KeyboardManager

class ViewController: UIViewController {
    private var keyboardToken: KeyboardObserverToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardObserver()
    }
    
    private func setupKeyboardObserver() {
        keyboardToken = KeyboardObserver.addObserver { event in
            switch event {
            case .willShow(let data):
                // Keyboard will appear
                print("Keyboard height: \(data.frame.end.height)")
                
            case .willHide(let data):
                // Keyboard will disappear
                print("Keyboard hiding with duration: \(data.animationDuration)")
                
            default:
                break
            }
        }
    }
}
```

## Constraint-Based Observation

For automatic constraint adjustment:

```swift
keyboardToken = KeyboardObserver.addObserver(
    superview: view,
    bottomConstraint: bottomConstraint,
    bottomOffset: 16.0,
    animated: true
)
```

## ScrollView Observation

For automatic scroll view adjustment:

```swift
keyboardToken = KeyboardObserver.addObserver(scrollView: scrollView)
```

> Important: Keep a strong reference to the returned `KeyboardObserverToken` to maintain the subscription. The observation automatically stops when the token is deallocated.