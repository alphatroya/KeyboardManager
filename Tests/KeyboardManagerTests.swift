//
//  KeyboardManagerTests.swift
//  KeyboardManagerTests
//
//  Created by Alexey Korolev on 14.01.17.
//  Copyright © 2017 Alexey Korolev. All rights reserved.
//

import XCTest
@testable import KeyboardManager

class KeyboardManagerTests: XCTestCase {

    let beginFrame = CGRect(x: 2, y: 6, width: 111, height: 222)
    let endFrame = CGRect(x: 1, y: 3, width: 111, height: 222)
    let animationDuration: Double = 444.0
    let curve = "Curve"
    let isLocal = true

    var notificationCenter: NotificationCenter!
    var keyboardManager: KeyboardManagerProtocol!

    override func setUp() {
        super.setUp()
        notificationCenter = NotificationCenter()
        keyboardManager = KeyboardManager(notificationCenter: notificationCenter)
    }

    override func tearDown() {
        super.tearDown()
        keyboardManager = nil
        notificationCenter = nil
    }

    func testCallClosureAfterWillAppearNotification() {
        var isTriggered = false
        keyboardManager.eventClosure = { event in
            if case let .willShow(data) = event,
                self.compareWithTestData(another: data) {
                isTriggered = true
            }
        }
        postTestNotification(name: Notification.Name.UIKeyboardWillShow)
        XCTAssertTrue(isTriggered)
    }

    func testCallClosureAfterDidAppearNotification() {
        var isTriggered = false
        keyboardManager.eventClosure = { event in
            if case let .didShow(data) = event,
                self.compareWithTestData(another: data) {
                isTriggered = true
            }
        }
        postTestNotification(name: Notification.Name.UIKeyboardDidShow)
        XCTAssertTrue(isTriggered)
    }

    func testCallClosureAfterWillHideNotification() {
        var isTriggered = false
        keyboardManager.eventClosure = { event in
            if case let .willHide(data) = event,
                self.compareWithTestData(another: data) {
                isTriggered = true
            }
        }
        postTestNotification(name: Notification.Name.UIKeyboardWillHide)
        XCTAssertTrue(isTriggered)
    }

    func testCallClosureAfterDidHideNotification() {
        var isTriggered = false
        keyboardManager.eventClosure = { event in
            if case let .didHide(data) = event,
                self.compareWithTestData(another: data) {
                isTriggered = true
            }
        }
        postTestNotification(name: Notification.Name.UIKeyboardDidHide)
        XCTAssertTrue(isTriggered)
    }

    func testNullObjectAfterWrongFormatNotification() {
        let expectation = self.expectation(description: "wrong notification expectation")
        keyboardManager.eventClosure = { event in
            let data = event.data
            let nullObject = KeyboardManagerEvent.Data.null()
            XCTAssertTrue(data == nullObject)
            expectation.fulfill()
        }
        postWrongTestNotification()
        waitForExpectations(timeout: 5)
    }

    func testNullObjectAfterNotificationWithoutUserDictionary() {
        let expectation = self.expectation(description: "null object expectation")
        keyboardManager.eventClosure = { event in
            let data = event.data
            let nullObject = KeyboardManagerEvent.Data.null()
            XCTAssertTrue(data == nullObject)
            expectation.fulfill()
        }
        notificationCenter.post(name: Notification.Name.UIKeyboardDidShow, object: nil)
        waitForExpectations(timeout: 5)
    }
}

// MARK: - Private methods

fileprivate extension KeyboardManagerTests {

    func postTestNotification(name: Notification.Name) {
        notificationCenter.post(name: name, object: nil, userInfo: [
            UIKeyboardFrameEndUserInfoKey: NSValue(cgRect: endFrame),
            UIKeyboardFrameBeginUserInfoKey: NSValue(cgRect: beginFrame),
            UIKeyboardAnimationDurationUserInfoKey: NSNumber(floatLiteral: animationDuration),
            UIKeyboardIsLocalUserInfoKey: NSNumber(booleanLiteral: isLocal),
            UIKeyboardAnimationCurveUserInfoKey: curve,
        ])
    }

    func postWrongTestNotification() {
        notificationCenter.post(name: Notification.Name.UIKeyboardDidShow, object: nil, userInfo: [
            UIKeyboardFrameEndUserInfoKey: NSValue(cgRect: endFrame),
            UIKeyboardAnimationCurveUserInfoKey: 10,
        ])
    }

    func compareWithTestData(another data: KeyboardManagerEvent.Data) -> Bool {
        let isFrameEqual = data.frame.begin == beginFrame &&
            data.frame.end == endFrame
        return isFrameEqual &&
            data.animationDuration == animationDuration &&
            data.animationCurve == curve &&
            data.isLocal == isLocal
    }
}

extension KeyboardManagerEvent.Data: Equatable {
}

public func ==(lhs: KeyboardManagerEvent.Data, rhs: KeyboardManagerEvent.Data) -> Bool {
    return lhs.animationCurve == rhs.animationCurve &&
        lhs.animationDuration == rhs.animationDuration &&
        lhs.isLocal == rhs.isLocal &&
        lhs.frame.begin == rhs.frame.begin &&
        lhs.frame.end == rhs.frame.end
}
