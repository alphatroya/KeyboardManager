//
//  KeyboardManagerTests.swift
//  KeyboardManagerTests
//
//  Created by Alexey Korolev on 14.01.17.
//  Copyright © 2017 Alexey Korolev. All rights reserved.
//

@testable import KeyboardManager
import UIKit
import XCTest

class KeyboardManagerTests: XCTestCase {
    let beginFrame = CGRect(x: 2, y: 6, width: 111, height: 222)
    let endFrame = CGRect(x: 1, y: 3, width: 111, height: 222)
    let animationDuration: Double = 4.0
    let curve = 7
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

    func testCallClosureAfterWillChangeFrameNotification() {
        var isTriggered = false
        keyboardManager.eventClosure = { event in
            if case let .willFrameChange(data) = event,
                self.compareWithTestData(another: data) {
                isTriggered = true
            }
        }
        postTestNotification(name: Notification.Name.UIKeyboardWillChangeFrame)
        XCTAssertTrue(isTriggered)
    }

    func testCallClosureAfterDidChangeFrameNotification() {
        var isTriggered = false
        keyboardManager.eventClosure = { event in
            if case let .didFrameChange(data) = event,
                self.compareWithTestData(another: data) {
                isTriggered = true
            }
        }
        postTestNotification(name: Notification.Name.UIKeyboardDidChangeFrame)
        XCTAssertTrue(isTriggered)
    }

    func testNullObjectAfterWrongFormatNotification() {
        let expectation = self.expectation(description: "wrong notification expectation")
        keyboardManager.eventClosure = { event in
            let data = event.data
            let nullObject = KeyboardManagerEvent.Data.null()
            XCTAssertTrue(self.compare(lhs: data, rhs: nullObject))
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
            XCTAssertTrue(self.compare(lhs: data, rhs: nullObject))
            expectation.fulfill()
        }
        notificationCenter.post(name: Notification.Name.UIKeyboardDidShow, object: nil)
        waitForExpectations(timeout: 5)
    }

    func testViewShouldChangeBottomInsetAfterKeyboardsWillAppear() {
        // GIVEN
        let view = UIView()
        let parentView = UIView()
        parentView.addSubview(view)
        let bottomConstrain = parentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let bottomOffset: CGFloat = 20.0
        // WHEN
        keyboardManager.bindToKeyboardNotifications(superview: view, bottomConstraint: bottomConstrain, bottomOffset: bottomOffset)
        postTestNotification(name: Notification.Name.UIKeyboardWillShow)
        // THEN
        XCTAssertEqual(bottomConstrain.constant, -endFrame.height)
    }

    func testViewShouldChangeBottomInsetAfterKeyboardWillChangeFrame() {
        // GIVEN
        let view = UIView()
        let parentView = UIView()
        parentView.addSubview(view)
        let bottomConstrain = parentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let bottomOffset: CGFloat = 20.0
        // WHEN
        keyboardManager.bindToKeyboardNotifications(superview: view, bottomConstraint: bottomConstrain, bottomOffset: bottomOffset)
        postTestNotification(name: Notification.Name.UIKeyboardWillChangeFrame)
        // THEN
        XCTAssertEqual(bottomConstrain.constant, -endFrame.height)
    }

    func testViewShouldChangeBottomInsetOnceAfterMultipleKeyboardsWillAppear() {
        // GIVEN
        let view = UIView()
        let parentView = UIView()
        parentView.addSubview(view)
        let bottomConstrain = parentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let bottomOffset: CGFloat = 20.0
        // WHEN
        keyboardManager.bindToKeyboardNotifications(superview: view, bottomConstraint: bottomConstrain, bottomOffset: bottomOffset)
        postTestNotification(name: Notification.Name.UIKeyboardWillShow)
        postTestNotification(name: Notification.Name.UIKeyboardWillShow)
        postTestNotification(name: Notification.Name.UIKeyboardWillShow)
        // THEN
        XCTAssertEqual(bottomConstrain.constant, -endFrame.height)
    }

    func testViewShouldChangeBottomInsetAfterKeyboardsWillDisappear() {
        // GIVEN
        let view = UIView()
        let parentView = UIView()
        parentView.addSubview(view)
        let bottomConstrain = parentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let bottomOffset: CGFloat = 20.0
        // WHEN
        keyboardManager.bindToKeyboardNotifications(superview: view, bottomConstraint: bottomConstrain, bottomOffset: bottomOffset)
        postTestNotification(name: Notification.Name.UIKeyboardWillHide)
        // THEN
        XCTAssertEqual(bottomConstrain.constant, -bottomOffset)
    }

    func testViewShouldChangeBottomInsetOnceAfterMultipleKeyboardsWillDisappear() {
        // GIVEN
        let view = UIView()
        let parentView = UIView()
        parentView.addSubview(view)
        let bottomConstrain = parentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let bottomOffset: CGFloat = 20.0
        // WHEN
        keyboardManager.bindToKeyboardNotifications(superview: view, bottomConstraint: bottomConstrain, bottomOffset: bottomOffset)
        postTestNotification(name: Notification.Name.UIKeyboardWillHide)
        postTestNotification(name: Notification.Name.UIKeyboardWillHide)
        postTestNotification(name: Notification.Name.UIKeyboardWillHide)
        // THEN
        XCTAssertEqual(bottomConstrain.constant, -bottomOffset)
    }

    func testViewShouldNotChangeBottomInsetAfterKeyboardsDidAppear() {
        // GIVEN
        let view = UIView()
        let parentView = UIView()
        parentView.addSubview(view)
        let bottomConstrain = parentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let bottomOffset: CGFloat = 20.0
        // WHEN
        keyboardManager.bindToKeyboardNotifications(superview: view, bottomConstraint: bottomConstrain, bottomOffset: bottomOffset)
        postTestNotification(name: Notification.Name.UIKeyboardDidShow)
        // THEN
        XCTAssertEqual(bottomConstrain.constant, 0)
    }

    func testViewShouldNotChangeBottomInsetAfterKeyboardsDidDisappear() {
        // GIVEN
        let view = UIView()
        let parentView = UIView()
        parentView.addSubview(view)
        let bottomConstrain = parentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let bottomOffset: CGFloat = 20.0
        // WHEN
        keyboardManager.bindToKeyboardNotifications(superview: view, bottomConstraint: bottomConstrain, bottomOffset: bottomOffset)
        postTestNotification(name: Notification.Name.UIKeyboardDidHide)
        // THEN
        XCTAssertEqual(bottomConstrain.constant, 0)
    }

    func testViewShouldNotChangeBottomInsetAfterKeyboardsDidChangeFrame() {
        // GIVEN
        let view = UIView()
        let parentView = UIView()
        parentView.addSubview(view)
        let bottomConstrain = parentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let bottomOffset: CGFloat = 20.0
        // WHEN
        keyboardManager.bindToKeyboardNotifications(superview: view, bottomConstraint: bottomConstrain, bottomOffset: bottomOffset)
        postTestNotification(name: Notification.Name.UIKeyboardDidChangeFrame)
        // THEN
        XCTAssertEqual(bottomConstrain.constant, 0)
    }

    func testViewShouldNotCancelScrollViewBindingWhileViewBindingActivated() {
        // GIVEN
        let scrollView = UIScrollView()
        let initialInsets = UIEdgeInsets(top: 10, left: 11, bottom: 12, right: 13)
        scrollView.contentInset = initialInsets

        let view = UIView()
        let parentView = UIView()
        parentView.addSubview(view)
        let bottomConstrain = parentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let bottomOffset: CGFloat = 20.0

        // WHEN
        keyboardManager.bindToKeyboardNotifications(scrollView: scrollView)
        keyboardManager.bindToKeyboardNotifications(superview: view, bottomConstraint: bottomConstrain, bottomOffset: bottomOffset)
        postTestNotification(name: Notification.Name.UIKeyboardWillShow)
        // THEN
        XCTAssertEqual(scrollView.contentInset.bottom, initialInsets.bottom + endFrame.height)
        XCTAssertEqual(bottomConstrain.constant, -endFrame.height)
    }

    func testDataPropertyInEventModel() {
        // GIVEN
        let frame = KeyboardManagerEvent.Frame(begin: beginFrame, end: endFrame)
        let data = KeyboardManagerEvent.Data(frame: frame, animationCurve: curve, animationDuration: animationDuration, isLocal: isLocal)
        // WHEN
        let didHideEvent = KeyboardManagerEvent.didHide(data)
        let willHideEvent = KeyboardManagerEvent.willHide(data)
        let willShowEvent = KeyboardManagerEvent.willShow(data)
        let didShowEvent = KeyboardManagerEvent.didShow(data)

        let didHideSuccess = compareWithTestData(another: didHideEvent.data)
        let willHideSuccess = compareWithTestData(another: willHideEvent.data)
        let willShowSuccess = compareWithTestData(another: willShowEvent.data)
        let didShowSuccess = compareWithTestData(another: didShowEvent.data)
        // THEN
        XCTAssertTrue(didHideSuccess)
        XCTAssertTrue(willHideSuccess)
        XCTAssertTrue(willShowSuccess)
        XCTAssertTrue(didShowSuccess)
    }
}
