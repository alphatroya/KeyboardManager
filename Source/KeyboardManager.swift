//
// Created by Alexey Korolev on 14.01.17.
// Copyright (c) 2017 Alexey Korolev. All rights reserved.
//

import UIKit

public typealias KeyboardManagerEventClosure = (KeyboardManagerEvent, KeyboardManagerEventData) -> Void

public enum KeyboardManagerEvent {
    case willShow
    case didShow
    case willHide
    case didHide
}

public struct KeyboardManagerEventData {
    public struct Frame {
        var begin: CGRect
        var end: CGRect
    }
    var frame: Frame
    var animationCurve: String
    var animationDuration: Double
    var isLocal: Bool
}

public protocol KeyboardManagerProtocol {

    var eventClosure: KeyboardManagerEventClosure? { get set }

}

public final class KeyboardManager {

    public var eventClosure: KeyboardManagerEventClosure?

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
        eventClosure?(.willShow, extractData(from: notification))
    }

    @objc
    private func keyboardDidShow(_ notification: Notification) {
        eventClosure?(.didShow, extractData(from: notification))
    }

    @objc
    private func keyboardWillHide(_ notification: Notification) {
        eventClosure?(.willHide, extractData(from: notification))
    }

    @objc
    private func keyboardDidHide(_ notification: Notification) {
        eventClosure?(.didHide, extractData(from: notification))
    }

    private func extractData(from notification: Notification) -> KeyboardManagerEventData {
        guard let endFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue,
              let beginFrame = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue,
              let curve = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? String,
              let isLocal = notification.userInfo?[UIKeyboardIsLocalUserInfoKey] as? NSNumber,
              let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else {
            fatalError("wrong notification was passed")
        }
        let frame = KeyboardManagerEventData.Frame(begin: beginFrame.cgRectValue, end: endFrame.cgRectValue)
        return KeyboardManagerEventData(
                frame: frame,
                animationCurve: curve,
                animationDuration: duration.doubleValue,
                isLocal: isLocal.boolValue
        )
    }

}

extension KeyboardManager: KeyboardManagerProtocol {
}
