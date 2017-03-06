//
//  KeyboardManagerTests.swift
//  KeyboardManagerTests
//
//  Created by Alexey Korolev on 14.01.17.
//  Copyright © 2017 Alexey Korolev. All rights reserved.
//

import Quick
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
            XCTAssertTrue(isTriggered)
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
            XCTAssertTrue(isTriggered)
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
            XCTAssertTrue(isTriggered)
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
            XCTAssertTrue(isTriggered)
        }

        it("return null object after wrong notification posted") {
            let expectation = self.expectation(description: "wrong notification expectation")
            keyboardManager.eventClosure = { (_, data) in
                let nullObject = KeyboardManagerEventData.null()
                XCTAssertTrue(data == nullObject)
                expectation.fulfill()
            }
            self.postWrongTestNotification()
            self.waitForExpectations(timeout: 5)
        }

        it("return null object after notification posted without user dictionary") {
            let expectation = self.expectation(description: "null object expectation")
            keyboardManager.eventClosure = { (_, data) in
                let nullObject = KeyboardManagerEventData.null()
                XCTAssertTrue(data == nullObject)
                expectation.fulfill()
            }
            self.notificationCenter.post(name: Notification.Name.UIKeyboardDidShow, object: nil)
            self.waitForExpectations(timeout: 5)
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

extension KeyboardManagerEventData: Equatable {

}

public func ==(lhs: KeyboardManagerEventData, rhs: KeyboardManagerEventData) -> Bool {
    return lhs.animationCurve == rhs.animationCurve &&
            lhs.animationDuration == rhs.animationDuration &&
            lhs.isLocal == rhs.isLocal &&
            lhs.frame.begin == rhs.frame.begin &&
            lhs.frame.end == rhs.frame.end

}
