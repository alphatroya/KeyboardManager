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
