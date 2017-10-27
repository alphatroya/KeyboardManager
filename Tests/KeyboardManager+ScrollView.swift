//
// Created by Alexey Korolev on 27.10.2017.
// Copyright (c) 2017 Alexey Korolev. All rights reserved.
//

import XCTest
import UIKit
@testable import KeyboardManager

extension KeyboardManagerTests {

    func testScrollViewInsetAdjustingAfterKeyboardAppear() {
        // GIVEN
        let scrollView = UIScrollView()
        let initialInsets = UIEdgeInsets(top: 10, left: 11, bottom: 12, right: 13)
        scrollView.contentInset = initialInsets
        // WHEN
        keyboardManager.bindToKeyboardNotifications(scrollView: scrollView)
        postTestNotification(name: Notification.Name.UIKeyboardWillShow)
        // THEN
        XCTAssertEqual(scrollView.contentInset.bottom, initialInsets.bottom + endFrame.height)
    }

    func testScrollViewInsetAdjustingAfterKeyboardWillChangeFrame() {
        // GIVEN
        let scrollView = UIScrollView()
        let initialInsets = UIEdgeInsets(top: 10, left: 11, bottom: 12, right: 13)
        scrollView.contentInset = initialInsets
        // WHEN
        keyboardManager.bindToKeyboardNotifications(scrollView: scrollView)
        postTestNotification(name: Notification.Name.UIKeyboardWillChangeFrame)
        // THEN
        XCTAssertEqual(scrollView.contentInset.bottom, initialInsets.bottom + endFrame.height)
    }

    func testScrollViewInsetAdjustingAfterMultipleKeyboardAppearNotifications() {
        // GIVEN
        let scrollView = UIScrollView()
        let initialInsets = UIEdgeInsets(top: 10, left: 11, bottom: 12, right: 13)
        scrollView.contentInset = initialInsets
        // WHEN
        keyboardManager.bindToKeyboardNotifications(scrollView: scrollView)
        postTestNotification(name: Notification.Name.UIKeyboardWillShow)
        postTestNotification(name: Notification.Name.UIKeyboardWillShow)
        // THEN
        XCTAssertEqual(scrollView.contentInset.bottom, initialInsets.bottom + endFrame.height)
    }

    func testScrollViewInsetAdjustingAfterKeyboardWillAppearAndChangeFrameNotifications() {
        // GIVEN
        let scrollView = UIScrollView()
        let initialInsets = UIEdgeInsets(top: 10, left: 11, bottom: 12, right: 13)
        scrollView.contentInset = initialInsets
        // WHEN
        keyboardManager.bindToKeyboardNotifications(scrollView: scrollView)
        postTestNotification(name: Notification.Name.UIKeyboardWillShow)
        postTestNotification(name: Notification.Name.UIKeyboardWillChangeFrame)
        // THEN
        XCTAssertEqual(scrollView.contentInset.bottom, initialInsets.bottom + endFrame.height)
    }

    func testResetBottomInsetAfterKeyboardDisappear() {
        // GIVEN
        let scrollView = UIScrollView()
        let initialInsets = UIEdgeInsets(top: 10, left: 11, bottom: 12, right: 13)
        scrollView.contentInset = initialInsets
        // WHEN
        keyboardManager.bindToKeyboardNotifications(scrollView: scrollView)
        postTestNotification(name: Notification.Name.UIKeyboardWillShow)
        postTestNotification(name: Notification.Name.UIKeyboardWillHide)
        // THEN
        XCTAssertEqual(scrollView.contentInset, initialInsets)
    }

    func testResetBottomInsetAfterMultipleKeyboardDisappearNotifications() {
        // GIVEN
        let scrollView = UIScrollView()
        let initialInsets = UIEdgeInsets(top: 10, left: 11, bottom: 12, right: 13)
        scrollView.contentInset = initialInsets
        // WHEN
        keyboardManager.bindToKeyboardNotifications(scrollView: scrollView)
        postTestNotification(name: Notification.Name.UIKeyboardWillShow)
        postTestNotification(name: Notification.Name.UIKeyboardWillHide)
        postTestNotification(name: Notification.Name.UIKeyboardWillHide)
        // THEN
        XCTAssertEqual(scrollView.contentInset, initialInsets)
    }

    func testScrollViewShouldNotChangeInsetsOnDidShowNotification() {
        // GIVEN
        let scrollView = UIScrollView()
        let initialInsets = UIEdgeInsets(top: 10, left: 11, bottom: 12, right: 13)
        scrollView.contentInset = initialInsets
        // WHEN
        keyboardManager.bindToKeyboardNotifications(scrollView: scrollView)
        postTestNotification(name: Notification.Name.UIKeyboardDidShow)
        // THEN
        XCTAssertEqual(scrollView.contentInset, initialInsets)
    }

    func testScrollViewShouldNotChangeInsetsOnDidChangeFrameNotification() {
        // GIVEN
        let scrollView = UIScrollView()
        let initialInsets = UIEdgeInsets(top: 10, left: 11, bottom: 12, right: 13)
        scrollView.contentInset = initialInsets
        // WHEN
        keyboardManager.bindToKeyboardNotifications(scrollView: scrollView)
        postTestNotification(name: Notification.Name.UIKeyboardDidChangeFrame)
        // THEN
        XCTAssertEqual(scrollView.contentInset, initialInsets)
    }

    func testScrollViewShouldNotChangeInsetsOnDidHideNotification() {
        // GIVEN
        let scrollView = UIScrollView()
        let initialInsets = UIEdgeInsets(top: 10, left: 11, bottom: 12, right: 13)
        scrollView.contentInset = initialInsets
        // WHEN
        keyboardManager.bindToKeyboardNotifications(scrollView: scrollView)
        postTestNotification(name: Notification.Name.UIKeyboardWillHide)
        // THEN
        XCTAssertEqual(scrollView.contentInset, initialInsets)
    }
}
