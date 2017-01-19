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

    let beginFrame = CGRect(x: 2, y: 6, width: 111, height: 222)
    let endFrame = CGRect(x: 1, y: 3, width: 111, height: 222)
    let animationDuration: Double = 444.0
    let curve = "Curve"
    let isLocal = true

    override func spec() {
        var keyboardManager: KeyboardManagerProtocol!

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
            keyboardManager.eventClosure = { (event, data) in
                if case .willShow = event,
                   self.compareWithTestData(another: data) {
                    isTriggered = true
                }
            }
            self.postTestNotification(name: Notification.Name.UIKeyboardWillShow)
            expect(isTriggered) == true
        }

        it("should call closure after keyboard did appear notification triggered") {
            var isTriggered = false
            keyboardManager.eventClosure = { (event, data) in
                if case .didShow = event,
                   self.compareWithTestData(another: data) {
                    isTriggered = true
                }
            }
            self.postTestNotification(name: Notification.Name.UIKeyboardDidShow)
            expect(isTriggered) == true
        }

        it("should call closure after keyboard will hide notification triggered") {
            var isTriggered = false
            keyboardManager.eventClosure = { (event, data) in
                if case .willHide = event,
                   self.compareWithTestData(another: data) {
                    isTriggered = true
                }
            }
            self.postTestNotification(name: Notification.Name.UIKeyboardWillHide)
            expect(isTriggered) == true
        }

        it("should call closure after keyboard did hide notification triggered") {
            var isTriggered = false
            keyboardManager.eventClosure = { (event, data) in
                if case .didHide = event,
                   self.compareWithTestData(another: data) {
                    isTriggered = true
                }
            }
            self.postTestNotification(name: Notification.Name.UIKeyboardDidHide)
            expect(isTriggered) == true
        }

        it("return null object after wrong notification posted") {
            var dataObject: KeyboardManagerEventData!
            keyboardManager.eventClosure = { (_, data) in
                dataObject = data
            }
            self.postWrongTestNotification()
            let nullObject = KeyboardManagerEventData.null()
            expect(dataObject.animationCurve).toEventually(equal(nullObject.animationCurve))
            expect(dataObject.animationDuration).toEventually(equal(nullObject.animationDuration))
            expect(dataObject.isLocal).toEventually(equal(nullObject.isLocal))
            expect(dataObject.frame.begin).toEventually(equal(nullObject.frame.begin))
            expect(dataObject.frame.end).toEventually(equal(nullObject.frame.end))
        }

        it("return null object after notification posted without user dictionary") {
            var dataObject: KeyboardManagerEventData!
            keyboardManager.eventClosure = { (_, data) in
                dataObject = data
            }
            self.notificationCenter.post(name: Notification.Name.UIKeyboardDidShow, object: nil)
            let nullObject = KeyboardManagerEventData.null()
            expect(dataObject.animationCurve).toEventually(equal(nullObject.animationCurve))
            expect(dataObject.animationDuration).toEventually(equal(nullObject.animationDuration))
            expect(dataObject.isLocal).toEventually(equal(nullObject.isLocal))
            expect(dataObject.frame.begin).toEventually(equal(nullObject.frame.begin))
            expect(dataObject.frame.end).toEventually(equal(nullObject.frame.end))
        }
    }

    private func postTestNotification(name: Notification.Name) {
        notificationCenter.post(name: name, object: nil, userInfo: [
                UIKeyboardFrameEndUserInfoKey: NSValue(cgRect: endFrame),
                UIKeyboardFrameBeginUserInfoKey: NSValue(cgRect: beginFrame),
                UIKeyboardAnimationDurationUserInfoKey: NSNumber(floatLiteral: animationDuration),
                UIKeyboardIsLocalUserInfoKey: NSNumber(booleanLiteral: isLocal),
                UIKeyboardAnimationCurveUserInfoKey: curve
        ])
    }

    private func postWrongTestNotification() {
        notificationCenter.post(name: Notification.Name.UIKeyboardDidShow, object: nil, userInfo: [
                UIKeyboardFrameEndUserInfoKey: NSValue(cgRect: endFrame),
                UIKeyboardAnimationCurveUserInfoKey: 10
        ])
    }

    private func compareWithTestData(another data: KeyboardManagerEventData) -> Bool {
        let isFrameEqual = data.frame.begin == beginFrame &&
                data.frame.end == endFrame
        return isFrameEqual &&
                data.animationDuration == animationDuration &&
                data.animationCurve == curve &&
                data.isLocal == isLocal
    }
}
