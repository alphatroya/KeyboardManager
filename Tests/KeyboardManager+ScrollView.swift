//
// Created by Alexey Korolev on 27.10.2017.
// Copyright (c) 2017 Alexey Korolev. All rights reserved.
//

@testable import KeyboardManager
import UIKit
import XCTest

extension KeyboardManagerTests {
    func testScrollViewInsetAdjustingAfterKeyboardAppear() {
        // GIVEN
        let scrollView = UIScrollView()
        let initialInsets = UIEdgeInsets(top: 10, left: 11, bottom: 12, right: 13)
        scrollView.contentInset = initialInsets
        // WHEN
        keyboardManager.bindToKeyboardNotifications(scrollView: scrollView)
        postTestNotification(name: UIResponder.keyboardWillShowNotification)
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
        postTestNotification(name: UIResponder.keyboardWillChangeFrameNotification)
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
        postTestNotification(name: UIResponder.keyboardWillShowNotification)
        postTestNotification(name: UIResponder.keyboardWillShowNotification)
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
        postTestNotification(name: UIResponder.keyboardWillShowNotification)
        postTestNotification(name: UIResponder.keyboardWillChangeFrameNotification)
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
        postTestNotification(name: UIResponder.keyboardWillShowNotification)
        postTestNotification(name: UIResponder.keyboardWillHideNotification)
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
        postTestNotification(name: UIResponder.keyboardWillShowNotification)
        postTestNotification(name: UIResponder.keyboardWillHideNotification)
        postTestNotification(name: UIResponder.keyboardWillHideNotification)
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
        postTestNotification(name: UIResponder.keyboardDidShowNotification)
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
        postTestNotification(name: UIResponder.keyboardDidChangeFrameNotification)
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
        postTestNotification(name: UIResponder.keyboardWillHideNotification)
        // THEN
        XCTAssertEqual(scrollView.contentInset, initialInsets)
    }
}
