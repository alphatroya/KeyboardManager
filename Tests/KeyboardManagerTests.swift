//
//  KeyboardManagerTests.swift
//  KeyboardManagerTests
//
//  Created by Alexey Korolev on 14.01.17.
//  Copyright © 2017 Alexey Korolev. All rights reserved.
//

import Quick
import Nimble
@testable import KeyboardManager

class KeyboardManagerTests: QuickSpec {
    var notificationCenter: NotificationCenter!

    override func spec() {
        var keyboardManager: KeyboardManagerProtocol!
        let keyboardFrame = CGRect(x: 1, y: 3, width: 111, height: 222)
        let animationDuration: Double = 444.0

        beforeEach {
            self.notificationCenter = NotificationCenter()
            keyboardManager = KeyboardManager(notificationCenter: self.notificationCenter)
        }

        afterEach {
            keyboardManager = nil
            self.notificationCenter = nil
        }

        it("should call closure after keyboard will appear notification triggered") {
            var isTriggered = false
            keyboardManager.eventClosure = { event in
                if case .willShow(let data) = event,
                   keyboardFrame == data.keyboardEndFrame,
                   animationDuration == data.animationDuration {
                    isTriggered = true
                }
            }
            self.postTestNotification(name: NSNotification.Name.UIKeyboardWillShow, endFrame: keyboardFrame, duration: animationDuration)
            expect(isTriggered) == true
        }

        it("should call closure after keyboard did appear notification triggered") {
            var isTriggered = false
            keyboardManager.eventClosure = { event in
                if case .didShow(let data) = event,
                   keyboardFrame == data.keyboardEndFrame,
                   animationDuration == data.animationDuration {
                    isTriggered = true
                }
            }
            self.postTestNotification(name: NSNotification.Name.UIKeyboardDidShow, endFrame: keyboardFrame, duration: animationDuration)
            expect(isTriggered) == true
        }
        it("should call closure after keyboard will hide notification triggered") {
            var isTriggered = false
            keyboardManager.eventClosure = { event in
                if case .willHide(let data) = event,
                   keyboardFrame == data.keyboardEndFrame,
                   animationDuration == data.animationDuration {
                    isTriggered = true
                }
            }
            self.postTestNotification(name: NSNotification.Name.UIKeyboardWillHide, endFrame: keyboardFrame, duration: animationDuration)
            expect(isTriggered) == true
        }
        it("should call closure after keyboard did hide notification triggered") {
            var isTriggered = false
            keyboardManager.eventClosure = { event in
                if case .didHide(let data) = event,
                   keyboardFrame == data.keyboardEndFrame,
                   animationDuration == data.animationDuration {
                    isTriggered = true
                }
            }
            self.postTestNotification(name: NSNotification.Name.UIKeyboardDidHide, endFrame: keyboardFrame, duration: animationDuration)
            expect(isTriggered) == true
        }
    }

    private func postTestNotification(name: Notification.Name, endFrame: CGRect, duration: Double) {
        notificationCenter.post(name: name, object: nil, userInfo: [
                UIKeyboardFrameEndUserInfoKey: NSValue(cgRect: endFrame),
                UIKeyboardAnimationDurationUserInfoKey: NSNumber(floatLiteral: duration)
        ])
    }
}
