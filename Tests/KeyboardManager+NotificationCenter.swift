//
// Created by Alexey Korolev on 25.10.2017.
// Copyright (c) 2017 Alexey Korolev. All rights reserved.
//

import UIKit

@testable import KeyboardManager
import XCTest

class KeyboardManagerNotificationCenterTest: XCTestCase {
    private var notificationCenter: NotificationCenterMock!
    var keyboardManager: KeyboardManagerProtocol!

    override func setUp() {
        super.setUp()
        notificationCenter = NotificationCenterMock()
        keyboardManager = KeyboardManager(notificationCenter: notificationCenter)
    }

    override func tearDown() {
        super.tearDown()
        keyboardManager = nil
        notificationCenter = nil
    }

    func testSubscribeForWillAppearNotification() {
        XCTAssertTrue(notificationCenter.isWillShow)
    }

    func testSubscribeForDidAppearNotification() {
        XCTAssertTrue(notificationCenter.isDidShow)
    }

    func testSubscribeForWillHideNotification() {
        XCTAssertTrue(notificationCenter.isWillHide)
    }

    func testSubscribeForDidHideNotification() {
        XCTAssertTrue(notificationCenter.isDidHide)
    }

    func testSubscribeForWillChangeFrameNotification() {
        XCTAssertTrue(notificationCenter.isWillChangeFrame)
    }

    func testSubscribeForDidChangeFrameNotification() {
        XCTAssertTrue(notificationCenter.isDidChangeFrame)
    }

    func testUnsubscribe() {
        keyboardManager = nil
        XCTAssertTrue(notificationCenter.isUnsubscribed)
    }
}

// swiftlint:disable force_unwrapping
private class NotificationCenterMock: NotificationCenter {
    var isWillShow: Bool = false
    var isDidShow: Bool = false
    var isWillHide: Bool = false
    var isDidHide: Bool = false
    var isWillChangeFrame: Bool = false
    var isDidChangeFrame: Bool = false
    var isUnsubscribed: Bool = false

    override func addObserver(_: Any, selector _: Selector, name aName: NSNotification.Name?, object _: Any?) {
        if case UIResponder.keyboardWillShowNotification = aName! {
            isWillShow = true
        } else if case UIResponder.keyboardDidShowNotification = aName! {
            isDidShow = true
        } else if case UIResponder.keyboardWillHideNotification = aName! {
            isWillHide = true
        } else if case UIResponder.keyboardDidHideNotification = aName! {
            isDidHide = true
        } else if case UIResponder.keyboardWillChangeFrameNotification = aName! {
            isWillChangeFrame = true
        } else if case UIResponder.keyboardDidChangeFrameNotification = aName! {
            isDidChangeFrame = true
        }
    }

    override func removeObserver(_: Any, name _: NSNotification.Name?, object _: Any?) {
        isUnsubscribed = true
    }
}
