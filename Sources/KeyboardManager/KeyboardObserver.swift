//
// MIT License
//
// Copyright (c) 2021 Alexey Korolev
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the  Software), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import UIKit

/// Token instance that internally store subscription, cancels subscription on deallocation
public final class KeyboardObserverToken {
    init(keyboardManager: KeyboardManager) {
        self.keyboardManager = keyboardManager
    }

    private var keyboardManager: KeyboardManager?

    /// Cancel subscription
    public func cancel() {
        keyboardManager = nil
    }
}

/// Keyboard observer is a namespace for subscription static methods
public enum KeyboardObserver {
    /**
       Add observer closure for observing keyboard events
       - Parameters:
         - notificationCenter: notification center to observe notifications
         - observer: closure for observing events
      - Returns: observer token that store subscription
     */
    public static func addObserver(
        _ notificationCenter: NotificationCenter = .default,
        _ observer: @escaping KeyboardManagerEventClosure
    ) -> KeyboardObserverToken {
        let keyboardManager = KeyboardManager(notificationCenter: notificationCenter)
        keyboardManager.addEventClosure(observer)
        return KeyboardObserverToken(keyboardManager: keyboardManager)
    }

    /**
        Automatically adjusts view's bottom constraint offset after receiving keyboard's notifications

        - Parameters:
          - _ notificationCenter: notification center to observe notifications
          - superview: parent view for adjusted constraints
          - bottomConstraint: current bottom constraint instance
          - bottomOffset: minimal preserved constraint offset value
          - safeAreaInsets: safe area generator for compensate offset for view controllers with tabbar
          - animated: should changes be animated
        - Returns: observer token that store subscription
     */
    public static func addObserver(
        _ notificationCenter: NotificationCenter = .default,
        superview: UIView,
        bottomConstraint: NSLayoutConstraint,
        bottomOffset: CGFloat = 0.0,
        safeAreaInsets: @escaping () -> UIEdgeInsets = { UIEdgeInsets.zero },
        animated: Bool = false
    ) -> KeyboardObserverToken {
        let keyboardManager = KeyboardManager(notificationCenter: notificationCenter)
        keyboardManager.bindToKeyboardNotifications(
            superview: superview,
            bottomConstraint: bottomConstraint,
            bottomOffset: bottomOffset,
            safeAreaInsets: safeAreaInsets,
            animated: animated
        )
        return KeyboardObserverToken(keyboardManager: keyboardManager)
    }

    /**
     Automatically adjusts scrollView's contentInset property with animation after receiving keyboard's notifications
      - Parameters:
          - _ notificationCenter: notification center to observe notifications
          - scrollView: scroll view instance
      - Returns: observer token that store subscription
     */
    public static func addObserver(
        _ notificationCenter: NotificationCenter = .default,
        scrollView: UIScrollView
    ) -> KeyboardObserverToken {
        let keyboardManager = KeyboardManager(notificationCenter: notificationCenter)
        keyboardManager.bindToKeyboardNotifications(
            scrollView: scrollView
        )
        return KeyboardObserverToken(keyboardManager: keyboardManager)
    }
}
