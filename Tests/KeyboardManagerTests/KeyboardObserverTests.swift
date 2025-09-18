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

import Foundation
@testable import KeyboardManager
import Testing

// MARK: - KeyboardObserverTests

@MainActor @Suite(.serialized)
class KeyboardObserverTests {
    // MARK: Properties

    var notificationCenter: NotificationCenterMock!

    // MARK: Lifecycle

    init() {
        notificationCenter = NotificationCenterMock()
    }

    deinit {
        notificationCenter = nil
    }

    // MARK: Functions

    @Test func keyboardObserverSubscription() {
        _ = KeyboardObserver.addObserver(notificationCenter) { _ in }
        #expect(notificationCenter.isWillShow)
        #expect(notificationCenter.isDidShow)
        #expect(notificationCenter.isWillHide)
        #expect(notificationCenter.isDidHide)
        #expect(notificationCenter.isWillChangeFrame)
        #expect(notificationCenter.isDidChangeFrame)
    }

    @Test func keyboardObserverUnsubscriptionOnDeallocation() {
        var token: KeyboardObserverToken? = KeyboardObserver.addObserver(notificationCenter) { _ in }
        token?.doNothing()
        #expect(!notificationCenter.isUnsubscribed)
        token = nil
        #expect(notificationCenter.isUnsubscribed)
    }
}

extension KeyboardObserverToken {
    /// this method does nothing to remove warning in L52
    func doNothing() {}
}
