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

import Foundation
@testable import KeyboardManager
import XCTest

class KeyboardObserverTests: XCTestCase {
    var notificationCenter: NotificationCenterMock!

    override func setUp() {
        super.setUp()
        notificationCenter = NotificationCenterMock()
    }

    override func tearDown() {
        notificationCenter = nil
        super.tearDown()
    }

    func testKeyboardObserverSubscription() {
        _ = KeyboardObserver.addObserver(notificationCenter) { _ in }
        XCTAssertTrue(notificationCenter.isWillShow)
        XCTAssertTrue(notificationCenter.isDidShow)
        XCTAssertTrue(notificationCenter.isWillHide)
        XCTAssertTrue(notificationCenter.isDidHide)
        XCTAssertTrue(notificationCenter.isWillChangeFrame)
        XCTAssertTrue(notificationCenter.isDidChangeFrame)
    }

    func testKeyboardObserverUnsubscriptionOnDeallocation() {
        var token: KeyboardObserverToken? = KeyboardObserver.addObserver(notificationCenter) { _ in }
        token?.doNothing()
        XCTAssertFalse(notificationCenter.isUnsubscribed)
        token = nil
        XCTAssertTrue(notificationCenter.isUnsubscribed)
    }

    func testObserverTokenCancelMethod() {
        let token = KeyboardObserver.addObserver(notificationCenter) { _ in }
        XCTAssertFalse(notificationCenter.isUnsubscribed)
        token.cancel()
        XCTAssertTrue(notificationCenter.isUnsubscribed)
    }
}

extension KeyboardObserverToken {
    /// this method does nothing to remove warning in L33
    func doNothing() {}
}
