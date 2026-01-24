//
// MIT License
//
// Copyright (c) 2017
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
import Testing
import UIKit

@MainActor @Suite("KeyboardManager ScrollView Tests")
struct KeyboardManagerScrollViewTests {
    // MARK: Properties

    let notificationCenter: NotificationCenter
    let keyboardManager: KeyboardManager

    // MARK: Lifecycle

    init() {
        notificationCenter = NotificationCenter()
        keyboardManager = KeyboardManager(notificationCenter: notificationCenter)
    }

    // MARK: Functions

    @Test("ScrollView inset adjusting after keyboard appear")
    func scrollViewInsetAdjustingAfterKeyboardAppear() {
        // GIVEN
        let scrollView = createTestScrollView()
        let initialInsets = TestConfiguration.defaultScrollViewInsets
        // WHEN
        keyboardManager.bindToKeyboardNotifications(scrollView: scrollView)
        postTestNotification(name: UIResponder.keyboardWillShowNotification)
        // THEN
        #expect(scrollView.contentInset.bottom == initialInsets.bottom + TestConfiguration.endFrame.height)
    }

    @Test("ScrollView inset adjusting after keyboard will change frame")
    func scrollViewInsetAdjustingAfterKeyboardWillChangeFrame() {
        // GIVEN
        let scrollView = createTestScrollView()
        let initialInsets = TestConfiguration.defaultScrollViewInsets
        // WHEN
        keyboardManager.bindToKeyboardNotifications(scrollView: scrollView)
        postTestNotification(name: UIResponder.keyboardWillChangeFrameNotification)
        // THEN
        #expect(scrollView.contentInset.bottom == initialInsets.bottom + TestConfiguration.endFrame.height)
    }

    @Test("ScrollView inset adjusting after multiple keyboard appear notifications")
    func scrollViewInsetAdjustingAfterMultipleKeyboardAppearNotifications() {
        // GIVEN
        let scrollView = UIScrollView()
        let initialInsets = UIEdgeInsets(top: 10, left: 11, bottom: 12, right: 13)
        scrollView.contentInset = initialInsets
        // WHEN
        keyboardManager.bindToKeyboardNotifications(scrollView: scrollView)
        postTestNotification(name: UIResponder.keyboardWillShowNotification)
        postTestNotification(name: UIResponder.keyboardWillShowNotification)
        // THEN
        #expect(scrollView.contentInset.bottom == initialInsets.bottom + TestConfiguration.endFrame.height)
    }

    @Test("ScrollView inset adjusting after keyboard will appear and change frame notifications")
    func scrollViewInsetAdjustingAfterKeyboardWillAppearAndChangeFrameNotifications() {
        // GIVEN
        let scrollView = UIScrollView()
        let initialInsets = UIEdgeInsets(top: 10, left: 11, bottom: 12, right: 13)
        scrollView.contentInset = initialInsets
        // WHEN
        keyboardManager.bindToKeyboardNotifications(scrollView: scrollView)
        postTestNotification(name: UIResponder.keyboardWillShowNotification)
        postTestNotification(name: UIResponder.keyboardWillChangeFrameNotification)
        // THEN
        #expect(scrollView.contentInset.bottom == initialInsets.bottom + TestConfiguration.endFrame.height)
    }

    @Test("Reset bottom inset after keyboard disappear")
    func resetBottomInsetAfterKeyboardDisappear() {
        // GIVEN
        let scrollView = UIScrollView()
        let initialInsets = UIEdgeInsets(top: 10, left: 11, bottom: 12, right: 13)
        scrollView.contentInset = initialInsets
        // WHEN
        keyboardManager.bindToKeyboardNotifications(scrollView: scrollView)
        postTestNotification(name: UIResponder.keyboardWillShowNotification)
        postTestNotification(name: UIResponder.keyboardWillHideNotification)
        // THEN
        #expect(scrollView.contentInset == initialInsets)
    }

    @Test("Reset bottom inset after multiple keyboard disappear notifications")
    func resetBottomInsetAfterMultipleKeyboardDisappearNotifications() {
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
        #expect(scrollView.contentInset == initialInsets)
    }

    @Test("ScrollView should not change insets on didShow notification")
    func scrollViewShouldNotChangeInsetsOnDidShowNotification() {
        // GIVEN
        let scrollView = UIScrollView()
        let initialInsets = UIEdgeInsets(top: 10, left: 11, bottom: 12, right: 13)
        scrollView.contentInset = initialInsets
        // WHEN
        keyboardManager.bindToKeyboardNotifications(scrollView: scrollView)
        postTestNotification(name: UIResponder.keyboardDidShowNotification)
        // THEN
        #expect(scrollView.contentInset == initialInsets)
    }

    @Test("ScrollView should not change insets on didChangeFrame notification")
    func scrollViewShouldNotChangeInsetsOnDidChangeFrameNotification() {
        // GIVEN
        let scrollView = UIScrollView()
        let initialInsets = UIEdgeInsets(top: 10, left: 11, bottom: 12, right: 13)
        scrollView.contentInset = initialInsets
        // WHEN
        keyboardManager.bindToKeyboardNotifications(scrollView: scrollView)
        postTestNotification(name: UIResponder.keyboardDidChangeFrameNotification)
        // THEN
        #expect(scrollView.contentInset == initialInsets)
    }

    @Test("ScrollView should not change insets on didHide notification")
    func scrollViewShouldNotChangeInsetsOnDidHideNotification() {
        // GIVEN
        let scrollView = UIScrollView()
        let initialInsets = UIEdgeInsets(top: 10, left: 11, bottom: 12, right: 13)
        scrollView.contentInset = initialInsets
        // WHEN
        keyboardManager.bindToKeyboardNotifications(scrollView: scrollView)
        postTestNotification(name: UIResponder.keyboardWillHideNotification)
        // THEN
        #expect(scrollView.contentInset == initialInsets)
    }
}
