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
        var begin: CGRect
        var end: CGRect
    }

    public struct Data {

        var frame: Frame
        var animationCurve: String
        var animationDuration: Double
        var isLocal: Bool

        static func null() -> Data {
            let frame = Frame(begin: CGRect.zero, end: CGRect.zero)
            return Data(frame: frame, animationCurve: "", animationDuration: 0.0, isLocal: false)
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

    fileprivate var initialScrollViewInsets = UIEdgeInsets.zero
    fileprivate var innerEventClosure: KeyboardManagerEventClosure?

    @objc
    private func keyboardWillShow(_ notification: Notification) {
        eventClosure?(.willShow(extractData(from: notification)))
        innerEventClosure?(.willShow(extractData(from: notification)))
    }

    @objc
    private func keyboardDidShow(_ notification: Notification) {
        eventClosure?(.didShow(extractData(from: notification)))
        innerEventClosure?(.didShow(extractData(from: notification)))
    }

    @objc
    private func keyboardWillHide(_ notification: Notification) {
        eventClosure?(.willHide(extractData(from: notification)))
        innerEventClosure?(.willHide(extractData(from: notification)))
    }

    @objc
    private func keyboardDidHide(_ notification: Notification) {
        eventClosure?(.didHide(extractData(from: notification)))
        innerEventClosure?(.didHide(extractData(from: notification)))
    }

    private func extractData(from notification: Notification) -> KeyboardManagerEvent.Data {
        guard let endFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let beginFrame = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue,
            let curve = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? String,
            let isLocal = notification.userInfo?[UIKeyboardIsLocalUserInfoKey] as? NSNumber,
            let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else {
            return KeyboardManagerEvent.Data.null()
        }
        let frame = KeyboardManagerEvent.Frame(begin: beginFrame.cgRectValue, end: endFrame.cgRectValue)
        return KeyboardManagerEvent.Data(
            frame: frame,
            animationCurve: curve,
            animationDuration: duration.doubleValue,
            isLocal: isLocal.boolValue
        )
    }
}

extension KeyboardManager: KeyboardManagerProtocol {
    public func bindToKeyboardNotifications(scrollView: UIScrollView) {
        initialScrollViewInsets = scrollView.contentInset
        innerEventClosure = { event in
            switch event {
            case let .willShow(data):
                scrollView.contentInset.bottom = self.initialScrollViewInsets.bottom + data.frame.end.size.height
            case .didHide:
                scrollView.contentInset.bottom = self.initialScrollViewInsets.bottom
            default:
                break
            }
        }
    }
}
