//
// MIT License
//
// Copyright (c) 2021 Alexey Korolev
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

import UIKit

@testable import KeyboardManager
import XCTest

class KeyboardManagerNotificationCenterTest: XCTestCase {
    private var notificationCenter: NotificationCenterMock!
    var keyboardManager: KeyboardManager!

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
class NotificationCenterMock: NotificationCenter {
    var isWillShow: Bool = false
    var isDidShow: Bool = false
    var isWillHide: Bool = false
    var isDidHide: Bool = false
    var isWillChangeFrame: Bool = false
    var isDidChangeFrame: Bool = false
    var isUnsubscribed: Bool = false

    override func addObserver(
        _: Any,
        selector _: Selector,
        name aName: NSNotification.Name?,
        object _: Any?
    ) {
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
