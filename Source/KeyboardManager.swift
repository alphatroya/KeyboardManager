//
// Created by Alexey Korolev on 14.01.17.
// Copyright (c) 2017 Alexey Korolev. All rights reserved.
//

import UIKit

public typealias KeyboardManagerEventClosure = (KeyboardManagerEvent) -> Void

/**
 The object contains type of keyboard transition and parsed `userInfo` dictionary
 data object
 */

public enum KeyboardManagerEvent {
    /**
     UIKeyboardWillShow notification case event
     */
    case willShow(KeyboardManagerEvent.Data)

    /**
     UIKeyboardDidShow notification case event
     */
    case didShow(KeyboardManagerEvent.Data)

    /**
     UIKeyboardWillHide notification case event
     */
    case willHide(KeyboardManagerEvent.Data)

    /**
     UIKeyboardDidHide notification case event
     */
    case didHide(KeyboardManagerEvent.Data)

    /**
     Object with `UIKeyboardFrameBeginUserInfoKey` and `UIKeyboardFrameEndUserInfoKey` notification's `userInfo` values
     */
    public struct Frame {
        /**
         `UIKeyboardFrameBeginUserInfoKey` notification's value
         */
        public var begin: CGRect

        /**
         `UIKeyboardFrameEndUserInfoKey` notification's value
         */
        public var end: CGRect
    }

    /**
     Keyboard notification's `userInfo` parsed object
     */
    public struct Data {

        /**
         `UIKeyboardFrameBeginUserInfoKey` and `UIKeyboardFrameEndUserInfoKey` notification's values
         */
        public var frame: Frame

        /**
         `UIKeyboardAnimationCurveUserInfoKey` notification's value
         */
        public var animationCurve: Int

        /**
         `UIKeyboardAnimationDurationUserInfoKey` notification's value
         */
        public var animationDuration: Double

        /**
         `UIKeyboardIsLocalUserInfoKey` notification's value
         */
        public var isLocal: Bool

        static func null() -> Data {
            let frame = Frame(begin: CGRect.zero, end: CGRect.zero)
            return Data(frame: frame, animationCurve: 0, animationDuration: 0.0, isLocal: false)
        }
    }

    var data: KeyboardManagerEvent.Data {
        switch self {
        case let .willShow(data):
            return data
        case let .didShow(data):
            return data
        case let .willHide(data):
            return data
        case let .didHide(data):
            return data
        }
    }
}

/**
 Protocol defines an interface for keyboard manager
 */

public protocol KeyboardManagerProtocol {

    /// Notify a client for a new parsed keyboard events
    var eventClosure: KeyboardManagerEventClosure? { get set }

    /**
     Helper method that automatically adjusts scrollView's contentInset property
     with animation after receive keyboard will appear and will hide notifications.

     - parameter scrollView: UIScrollView instance, that will be modified after notifications emerged
     */
    func bindToKeyboardNotifications(scrollView: UIScrollView)
}

/**
 Keyboard manager class that implement KeyboardManagerProtocol
 */

public final class KeyboardManager {

    /// Notify a client for a new parsed keyboard events
    public var eventClosure: KeyboardManagerEventClosure?

    let notificationCenter: NotificationCenter
    /**
     Creates a new keyboard manager instance
     - parameter notificationCenter: notification center needed to observe new keyboard events such a UIKeyboardWillShow and etc
     */
    public init(notificationCenter: NotificationCenter) {
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

    fileprivate var initialScrollViewInsets = UIEdgeInsets.zero
    fileprivate var innerEventClosure: KeyboardManagerEventClosure?

    @objc
    private func keyboardWillShow(_ notification: Notification) {
        invokeClosures(.willShow(extractData(from: notification)))
    }

    @objc
    private func keyboardDidShow(_ notification: Notification) {
        invokeClosures(.didShow(extractData(from: notification)))
    }

    @objc
    private func keyboardWillHide(_ notification: Notification) {
        invokeClosures(.willHide(extractData(from: notification)))
    }

    @objc
    private func keyboardDidHide(_ notification: Notification) {
        invokeClosures(.didHide(extractData(from: notification)))
    }

    private func invokeClosures(_ event: KeyboardManagerEvent) {
        eventClosure?(event)
        innerEventClosure?(event)
    }

    private func extractData(from notification: Notification) -> KeyboardManagerEvent.Data {
        guard let endFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let beginFrame = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue,
            let curve = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber,
            let isLocal = notification.userInfo?[UIKeyboardIsLocalUserInfoKey] as? NSNumber,
            let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else {
            return KeyboardManagerEvent.Data.null()
        }
        let frame = KeyboardManagerEvent.Frame(begin: beginFrame.cgRectValue, end: endFrame.cgRectValue)
        return KeyboardManagerEvent.Data(
            frame: frame,
            animationCurve: curve.intValue,
            animationDuration: duration.doubleValue,
            isLocal: isLocal.boolValue
        )
    }
}

extension KeyboardManager: KeyboardManagerProtocol {
    /**
     Helper method that automatically adjusts scrollView's contentInset property
     with animation after receive keyboard will appear and will hide notifications.

     - parameter scrollView: UIScrollView instance, that will be modified after notifications emerged
     */
    public func bindToKeyboardNotifications(scrollView: UIScrollView) {
        initialScrollViewInsets = scrollView.contentInset
        innerEventClosure = { [unowned self] event in
            self.handle(by: scrollView, event: event)
        }
    }

    private func handle(by scrollView: UIScrollView, event: KeyboardManagerEvent) {
        switch event {
        case let .willShow(data):
            UIView.animateKeyframes(
                withDuration: data.animationDuration,
                delay: 0,
                options: UIViewKeyframeAnimationOptions(rawValue: UInt(data.animationCurve)),
                animations: {
                    scrollView.contentInset.bottom = self.initialScrollViewInsets.bottom + data.frame.end.size.height
            })
        case let .willHide(data):
            UIView.animateKeyframes(
                withDuration: data.animationDuration,
                delay: 0,
                options: UIViewKeyframeAnimationOptions(rawValue: UInt(data.animationCurve)),
                animations: {
                    scrollView.contentInset.bottom = self.initialScrollViewInsets.bottom
            })
        default:
            break
        }
    }
}
