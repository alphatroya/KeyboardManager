//
// Copyright © 2020 Alexey Korolev <alphatroya@gmail.com>
//

import UIKit

/// Keyboard's notification observing closure
public typealias KeyboardManagerEventClosure = (KeyboardManagerEvent) -> Void

/// Keyboard transition metadata object
public enum KeyboardManagerEvent {
    /// UIKeyboardWillShow notification case event
    case willShow(KeyboardManagerEvent.Data)

    /// UIKeyboardDidShow notification case event
    case didShow(KeyboardManagerEvent.Data)

    /// UIKeyboardWillHide notification case event
    case willHide(KeyboardManagerEvent.Data)

    /// UIKeyboardDidHide notification case event
    case didHide(KeyboardManagerEvent.Data)

    /// UIKeyboardWillChangeFrame notification case event
    case willFrameChange(KeyboardManagerEvent.Data)

    /// UIKeyboardDidChangeFrame notification case event
    case didFrameChange(KeyboardManagerEvent.Data)

    /// `UIKeyboardFrameBeginUserInfoKey` and `UIKeyboardFrameEndUserInfoKey` values
    public struct Frame {
        /// Begin transition keyboard frame
        public var begin: CGRect

        /// Final transition keyboard frame
        public var end: CGRect
    }

    /// Notification `userInfo` metadata info
    public struct Data {
        /// Keyboard frames
        public var frame: Frame

        /// Animation curve value
        public var animationCurve: Int

        /// Transition animation duration value
        public var animationDuration: Double

        /// `UIKeyboardIsLocalUserInfoKey` `userInfo` value
        public var isLocal: Bool

        static func null() -> Data {
            let frame = Frame(begin: CGRect.zero, end: CGRect.zero)
            return Data(frame: frame, animationCurve: 0, animationDuration: 0.0, isLocal: false)
        }
    }

    var data: KeyboardManagerEvent.Data {
        switch self {
        case let .willShow(data),
             let .didShow(data),
             let .willHide(data),
             let .didHide(data),
             let .willFrameChange(data),
             let .didFrameChange(data):
            return data
        }
    }
}

/// Manager class who monitors keyboard's notification
public final class KeyboardManager {
    /// Notify a client for a new parsed keyboard events
    public var eventClosure: KeyboardManagerEventClosure?

    let notificationCenter: NotificationCenter

    /**
     Keyboard manager instance constructor
     - parameter notificationCenter: observed notification center
     */
    public init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter

        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardDidShow(_:)),
            name: UIResponder.keyboardDidShowNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardDidHide(_:)),
            name: UIResponder.keyboardDidHideNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardDidChangeFrame(_:)),
            name: UIResponder.keyboardDidChangeFrameNotification,
            object: nil
        )
    }

    deinit {
        notificationCenter.removeObserver(self)
    }

    private var innerEventClosures: [KeyboardManagerEventClosure] = []

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

    @objc
    private func keyboardWillChangeFrame(_ notification: Notification) {
        invokeClosures(.willFrameChange(extractData(from: notification)))
    }

    @objc
    private func keyboardDidChangeFrame(_ notification: Notification) {
        invokeClosures(.didFrameChange(extractData(from: notification)))
    }

    private func invokeClosures(_ event: KeyboardManagerEvent) {
        eventClosure?(event)
        innerEventClosures.forEach { $0(event) }
    }

    private func extractData(from notification: Notification) -> KeyboardManagerEvent.Data {
        guard let endFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let beginFrame = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue,
              let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber,
              let isLocal = notification.userInfo?[UIResponder.keyboardIsLocalUserInfoKey] as? NSNumber,
              let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber
        else {
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

public extension KeyboardManager {
    /**
     Automatically adjusts view's bottom constraint offset after receiving keyboard's notifications

     - parameter superview: parent view for adjusted constraints
     - parameter bottomConstraint: current bottom constraint instance
     - parameter bottomOffset: minimal preserved constraint offset value
     - parameter animated: should changes be animated
     */
    func bindToKeyboardNotifications(
        superview: UIView,
        bottomConstraint: NSLayoutConstraint,
        bottomOffset: CGFloat = 0.0,
        animated: Bool = false
    ) {
        let closure: KeyboardManagerEventClosure = {
            let animationDuration: Double
            switch $0 {
            case let .willShow(data), let .willFrameChange(data):
                animationDuration = data.animationDuration
                bottomConstraint.constant = -data.frame.end.size.height
            case let .willHide(data):
                animationDuration = data.animationDuration
                bottomConstraint.constant = -bottomOffset
            default:
                return
            }
            if animated {
                UIView.animate(withDuration: animationDuration) {
                    superview.layoutIfNeeded()
                }
            } else {
                superview.layoutIfNeeded()
            }
        }
        innerEventClosures += [closure]
    }

    /**
     Automatically adjusts scrollView's contentInset property with animation after receivign keyboard's notifications
     - parameter scrollView: current scroll view instance
     */
    func bindToKeyboardNotifications(scrollView: UIScrollView) {
        let initialScrollViewInsets = scrollView.contentInset
        let closure = { [unowned self] event in
            self.handle(by: scrollView, event: event, initialInset: initialScrollViewInsets)
        }
        innerEventClosures += [closure]
    }

    private func handle(by scrollView: UIScrollView, event: KeyboardManagerEvent, initialInset: UIEdgeInsets) {
        switch event {
        case let .willShow(data), let .willFrameChange(data):
            UIView.animateKeyframes(
                withDuration: data.animationDuration,
                delay: 0,
                options: UIView.KeyframeAnimationOptions(rawValue: UInt(data.animationCurve)),
                animations: {
                    let inset = initialInset.bottom + data.frame.end.size.height
                    scrollView.contentInset.bottom = inset
                    if #available(iOS 11.1, *) {
                        scrollView.verticalScrollIndicatorInsets.bottom = inset
                    }
                }
            )
        case let .willHide(data):
            UIView.animateKeyframes(
                withDuration: data.animationDuration,
                delay: 0,
                options: UIView.KeyframeAnimationOptions(rawValue: UInt(data.animationCurve)),
                animations: {
                    scrollView.contentInset.bottom = initialInset.bottom
                    if #available(iOS 11.1, *) {
                        scrollView.verticalScrollIndicatorInsets.bottom = initialInset.bottom
                    }
                }
            )
        default:
            break
        }
    }
}
