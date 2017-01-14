//
// Created by Alexey Korolev on 14.01.17.
// Copyright (c) 2017 Alexey Korolev. All rights reserved.
//

import UIKit

public enum KeyboardManagerEvent {
    case willShow(data: KeyboardManagerData)
    case didShow(data: KeyboardManagerData)
    case willHide(data: KeyboardManagerData)
    case didHide(data: KeyboardManagerData)
}

public typealias KeyboardManagerEventClosure = (KeyboardManagerEvent) -> Void
public typealias KeyboardManagerData = (keyboardEndFrame: CGRect, animationDuration: Double)

public protocol KeyboardManagerProtocol {

    var eventClosure: KeyboardManagerEventClosure? { get set }

}

public final class KeyboardManager {
    let notificationCenter: NotificationCenter
    init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter

        notificationCenter.addObserver(self,
                selector: #selector(keyboardWillShow(_:)),
                name: Notification.Name.UIKeyboardWillShow,
                object: nil
        )
        notificationCenter.addObserver(self,
                selector: #selector(keyboardDidShow(_:)),
                name: Notification.Name.UIKeyboardDidShow,
                object: nil
        )
        notificationCenter.addObserver(self,
                selector: #selector(keyboardWillHide(_:)),
                name: Notification.Name.UIKeyboardWillHide,
                object: nil
        )
        notificationCenter.addObserver(self,
                selector: #selector(keyboardDidHide(_:)),
                name: Notification.Name.UIKeyboardDidHide,
                object: nil
        )
    }

    deinit {
        notificationCenter.removeObserver(self)
    }

    @objc
    private func keyboardWillShow(_ notification: Notification) {
        eventClosure?(.willShow(data: data(for: notification)))
    }

    @objc
    private func keyboardDidShow(_ notification: Notification) {
        eventClosure?(.didShow(data: data(for: notification)))
    }

    @objc
    private func keyboardWillHide(_ notification: Notification) {
        eventClosure?(.willHide(data: data(for: notification)))
    }

    @objc
    private func keyboardDidHide(_ notification: Notification) {
        eventClosure?(.didHide(data: data(for: notification)))
    }

    private func data(for notification: Notification) -> KeyboardManagerData {
        guard let frameValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue,
              let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else {
            fatalError("wrong notification was passed")
        }
        return (keyboardEndFrame: frameValue.cgRectValue, animationDuration: duration.doubleValue)
    }

    public var eventClosure: KeyboardManagerEventClosure?

}

extension KeyboardManager: KeyboardManagerProtocol {
}
