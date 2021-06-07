//
// MIT License
//
// Copyright (c) 2021
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

final class KeyboardManager {
    let notificationCenter: NotificationCenter

    init(notificationCenter: NotificationCenter = .default) {
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

    private var observers: [KeyboardManagerEventClosure] = []

    func addEventClosure(_ eventClosure: @escaping KeyboardManagerEventClosure) {
        observers.append(eventClosure)
    }

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
        observers.forEach { $0(event) }
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

    func bindToKeyboardNotifications(
        superview: UIView,
        bottomConstraint: NSLayoutConstraint,
        bottomOffset: CGFloat = 0.0,
        safeAreaInsets: @escaping () -> UIEdgeInsets = { UIEdgeInsets.zero },
        animated: Bool = false
    ) {
        let closure: KeyboardManagerEventClosure = {
            let animationDuration: Double
            switch $0 {
            case let .willShow(data), let .willFrameChange(data):
                animationDuration = data.animationDuration
                bottomConstraint.constant = -data.frame.end.height + safeAreaInsets().bottom
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
        observers += [closure]
    }

    func bindToKeyboardNotifications(scrollView: UIScrollView) {
        let initialScrollViewInsets = scrollView.contentInset
        let closure = { [unowned self] event in
            self.handle(by: scrollView, event: event, initialInset: initialScrollViewInsets)
        }
        observers += [closure]
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
