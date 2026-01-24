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

// MARK: - TestConfiguration

/// Shared test configuration constants used across multiple test suites
enum TestConfiguration {
    static let beginFrame = CGRect(x: 2, y: 6, width: 111, height: 222)
    static let endFrame = CGRect(x: 1, y: 3, width: 111, height: 222)
    static let animationDuration: Double = 4.0
    static let curve = 7
    static let isLocal = true

    // ScrollView test configuration
    static let defaultScrollViewInsets = UIEdgeInsets(top: 10, left: 11, bottom: 12, right: 13)
    static let defaultBottomOffset: CGFloat = 20.0
}

// MARK: - NotificationTestCase

/// Test case data for parameterized notification tests
struct NotificationTestCase {
    // MARK: Static Properties

    static let allCases: [NotificationTestCase] = [
        NotificationTestCase(
            notificationName: UIResponder.keyboardWillShowNotification,
            expectedEventType: "willShow",
            description: "willShow notification",
        ),
        NotificationTestCase(
            notificationName: UIResponder.keyboardDidShowNotification,
            expectedEventType: "didShow",
            description: "didShow notification",
        ),
        NotificationTestCase(
            notificationName: UIResponder.keyboardWillHideNotification,
            expectedEventType: "willHide",
            description: "willHide notification",
        ),
        NotificationTestCase(
            notificationName: UIResponder.keyboardDidHideNotification,
            expectedEventType: "didHide",
            description: "didHide notification",
        ),
        NotificationTestCase(
            notificationName: UIResponder.keyboardWillChangeFrameNotification,
            expectedEventType: "willFrameChange",
            description: "willChangeFrame notification",
        ),
        NotificationTestCase(
            notificationName: UIResponder.keyboardDidChangeFrameNotification,
            expectedEventType: "didFrameChange",
            description: "didChangeFrame notification",
        ),
    ]

    // MARK: Properties

    let notificationName: Notification.Name
    let expectedEventType: String
    let description: String

    // MARK: Functions

    /// Checks if the event matches the expected type
    func matchesEvent(_ event: KeyboardManagerEvent) -> Bool {
        switch (expectedEventType, event) {
        case ("willShow", .willShow):
            true
        case ("didShow", .didShow):
            true
        case ("willHide", .willHide):
            true
        case ("didHide", .didHide):
            true
        case ("willFrameChange", .willFrameChange):
            true
        case ("didFrameChange", .didFrameChange):
            true
        default:
            false
        }
    }
}

// MARK: - Shared Test Helpers

extension KeyboardManagerTests {
    func postTestNotification(name: Notification.Name) {
        notificationCenter.post(name: name, object: nil, userInfo: [
            UIResponder.keyboardFrameEndUserInfoKey: NSValue(cgRect: TestConfiguration.endFrame),
            UIResponder.keyboardFrameBeginUserInfoKey: NSValue(cgRect: TestConfiguration.beginFrame),
            UIResponder.keyboardAnimationDurationUserInfoKey: TestConfiguration.animationDuration,
            UIResponder.keyboardIsLocalUserInfoKey: TestConfiguration.isLocal,
            UIResponder.keyboardAnimationCurveUserInfoKey: TestConfiguration.curve,
        ])
    }

    func postWrongTestNotification() {
        notificationCenter.post(name: UIResponder.keyboardDidShowNotification, object: nil, userInfo: [
            UIResponder.keyboardFrameEndUserInfoKey: NSValue(cgRect: TestConfiguration.endFrame),
            UIResponder.keyboardAnimationCurveUserInfoKey: 10,
        ])
    }

    func compareWithTestData(another data: KeyboardManagerEvent.Data) -> Bool {
        let isFrameEqual = data.frame.begin == TestConfiguration.beginFrame &&
            data.frame.end == TestConfiguration.endFrame
        return isFrameEqual &&
            data.animationDuration == TestConfiguration.animationDuration &&
            data.animationCurve == TestConfiguration.curve &&
            data.isLocal == TestConfiguration.isLocal
    }

    func compare(lhs: KeyboardManagerEvent.Data, rhs: KeyboardManagerEvent.Data) -> Bool {
        lhs.animationCurve == rhs.animationCurve &&
            lhs.animationDuration == rhs.animationDuration &&
            lhs.isLocal == rhs.isLocal &&
            lhs.frame.begin == rhs.frame.begin &&
            lhs.frame.end == rhs.frame.end
    }

    /// Creates a configured view with constraint setup for testing
    func createTestView() -> (view: UIView, parentView: UIView, bottomConstraint: NSLayoutConstraint) {
        let view = UIView()
        let parentView = UIView()
        parentView.addSubview(view)
        let bottomConstraint = parentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        return (view, parentView, bottomConstraint)
    }
}

extension KeyboardManagerScrollViewTests {
    func postTestNotification(name: Notification.Name) {
        notificationCenter.post(name: name, object: nil, userInfo: [
            UIResponder.keyboardFrameEndUserInfoKey: NSValue(cgRect: TestConfiguration.endFrame),
            UIResponder.keyboardFrameBeginUserInfoKey: NSValue(cgRect: TestConfiguration.beginFrame),
            UIResponder.keyboardAnimationDurationUserInfoKey: TestConfiguration.animationDuration,
            UIResponder.keyboardIsLocalUserInfoKey: TestConfiguration.isLocal,
            UIResponder.keyboardAnimationCurveUserInfoKey: TestConfiguration.curve,
        ])
    }

    /// Creates a configured ScrollView for testing
    func createTestScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.contentInset = TestConfiguration.defaultScrollViewInsets
        return scrollView
    }
}

// MARK: - Shared Test Mocks

/// Shared NotificationCenter mock used across multiple test suites
class NotificationCenterMock: NotificationCenter, @unchecked Sendable {
    // MARK: Properties

    var isWillShow: Bool = false
    var isDidShow: Bool = false
    var isWillHide: Bool = false
    var isDidHide: Bool = false
    var isWillChangeFrame: Bool = false
    var isDidChangeFrame: Bool = false
    var isUnsubscribed: Bool = false

    // MARK: Overridden Functions

    override func addObserver(
        _: Any,
        selector _: Selector,
        name aName: NSNotification.Name?,
        object _: Any?,
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
