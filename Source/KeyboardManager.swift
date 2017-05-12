//
// Created by Alexey Korolev on 14.01.17.
// Copyright (c) 2017 Alexey Korolev. All rights reserved.
//

import UIKit

public typealias KeyboardManagerEventClosure = (KeyboardManagerEvent) -> Void

public enum KeyboardManagerEvent {
    case willShow(KeyboardManagerEvent.Data)
    case didShow(KeyboardManagerEvent.Data)
    case willHide(KeyboardManagerEvent.Data)
    case didHide(KeyboardManagerEvent.Data)

    public struct Frame {
        public var begin: CGRect
        public var end: CGRect
    }

    public struct Data {

        public var frame: Frame
        public var animationCurve: Int
        public var animationDuration: Double
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

public protocol KeyboardManagerProtocol {

    var eventClosure: KeyboardManagerEventClosure? { get set }

    func bindToKeyboardNotifications(scrollView: UIScrollView)
}

public final class KeyboardManager {

    public var eventClosure: KeyboardManagerEventClosure?

    let notificationCenter: NotificationCenter
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
        let data = extractData(from: notification)
        eventClosure?(.willShow(data))
        innerEventClosure?(.willShow(data))
    }

    @objc
    private func keyboardDidShow(_ notification: Notification) {
        let data = extractData(from: notification)
        eventClosure?(.didShow(data))
        innerEventClosure?(.didShow(data))
    }

    @objc
    private func keyboardWillHide(_ notification: Notification) {
        let data = extractData(from: notification)
        eventClosure?(.willHide(data))
        innerEventClosure?(.willHide(data))
    }

    @objc
    private func keyboardDidHide(_ notification: Notification) {
        let data = extractData(from: notification)
        eventClosure?(.didHide(data))
        innerEventClosure?(.didHide(data))
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
    public func bindToKeyboardNotifications(scrollView: UIScrollView) {
        initialScrollViewInsets = scrollView.contentInset
        innerEventClosure = { [unowned self] event in
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
}
