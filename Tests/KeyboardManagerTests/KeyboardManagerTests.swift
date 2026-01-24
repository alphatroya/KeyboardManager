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

@MainActor @Suite("KeyboardManager Tests")
struct KeyboardManagerTests {
    // MARK: Properties

    let notificationCenter: NotificationCenter

    // MARK: Lifecycle

    init() {
        notificationCenter = NotificationCenter()
    }

    // MARK: Functions

    @Test("Keyboard notification events", arguments: NotificationTestCase.allCases)
    func keyboardNotificationEvents(testCase: NotificationTestCase) {
        var isTriggered = false
        let observerToken = KeyboardObserver.addObserver(notificationCenter) { event in
            if testCase.matchesEvent(event), compareWithTestData(another: event.data) {
                isTriggered = true
            }
        }
        _ = observerToken // Avoid unused variable warning
        postTestNotification(name: testCase.notificationName)
        #expect(isTriggered, "Failed to trigger \(testCase.description)")
    }

    @Test("Call closure after didShow notification")
    func callClosureAfterDidAppearNotification() {
        var isTriggered = false
        let observerToken = KeyboardObserver.addObserver(notificationCenter) { event in
            if case let .didShow(data) = event,
               compareWithTestData(another: data)
            {
                isTriggered = true
            }
        }
        _ = observerToken // Avoid unused variable warning
        postTestNotification(name: UIResponder.keyboardDidShowNotification)
        #expect(isTriggered)
    }

    @Test("Call closure after willHide notification")
    func callClosureAfterWillHideNotification() {
        var isTriggered = false
        let observerToken = KeyboardObserver.addObserver(notificationCenter) { event in
            if case let .willHide(data) = event,
               compareWithTestData(another: data)
            {
                isTriggered = true
            }
        }
        _ = observerToken // Avoid unused variable warning
        postTestNotification(name: UIResponder.keyboardWillHideNotification)
        #expect(isTriggered)
    }

    @Test("Call closure after didHide notification")
    func callClosureAfterDidHideNotification() {
        var isTriggered = false
        let observerToken = KeyboardObserver.addObserver(notificationCenter) { event in
            if case let .didHide(data) = event,
               compareWithTestData(another: data)
            {
                isTriggered = true
            }
        }
        _ = observerToken // Avoid unused variable warning
        postTestNotification(name: UIResponder.keyboardDidHideNotification)
        #expect(isTriggered)
    }

    @Test("Call closure after willChangeFrame notification")
    func callClosureAfterWillChangeFrameNotification() {
        var isTriggered = false
        let observerToken = KeyboardObserver.addObserver(notificationCenter) { event in
            if case let .willFrameChange(data) = event,
               compareWithTestData(another: data)
            {
                isTriggered = true
            }
        }
        _ = observerToken // Avoid unused variable warning
        postTestNotification(name: UIResponder.keyboardWillChangeFrameNotification)
        #expect(isTriggered)
    }

    @Test("Call closure after didChangeFrame notification")
    func callClosureAfterDidChangeFrameNotification() {
        var isTriggered = false
        let observerToken = KeyboardObserver.addObserver(notificationCenter) { event in
            if case let .didFrameChange(data) = event,
               compareWithTestData(another: data)
            {
                isTriggered = true
            }
        }
        _ = observerToken // Avoid unused variable warning
        postTestNotification(name: UIResponder.keyboardDidChangeFrameNotification)
        #expect(isTriggered)
    }

    @Test("Null object after wrong format notification")
    func nullObjectAfterWrongFormatNotification() async {
        await confirmation("wrong notification expectation") { confirm in
            let observerToken = KeyboardObserver.addObserver(notificationCenter) { event in
                let data = event.data
                let nullObject = KeyboardManagerEvent.Data.null()
                #expect(compare(lhs: data, rhs: nullObject))
                confirm()
            }
            _ = observerToken // Avoid unused variable warning
            postWrongTestNotification()
        }
    }

    @Test("Null object after notification without user dictionary")
    func nullObjectAfterNotificationWithoutUserDictionary() async {
        await confirmation("null object expectation") { confirm in
            let observerToken = KeyboardObserver.addObserver(notificationCenter) { event in
                let data = event.data
                let nullObject = KeyboardManagerEvent.Data.null()
                #expect(compare(lhs: data, rhs: nullObject))
                confirm()
            }
            _ = observerToken // Avoid unused variable warning
            notificationCenter.post(name: UIResponder.keyboardDidShowNotification, object: nil)
        }
    }

    @Test("View should change bottom inset after keyboard will appear")
    func viewShouldChangeBottomInsetAfterKeyboardsWillAppear() {
        // GIVEN
        let (view, _, bottomConstraint) = createTestView()
        let bottomOffset = TestConfiguration.defaultBottomOffset
        // WHEN
        let observerToken = KeyboardObserver.addObserver(
            notificationCenter,
            superview: view,
            bottomConstraint: bottomConstraint,
            bottomOffset: bottomOffset,
        )
        _ = observerToken // Avoid unused variable warning
        postTestNotification(name: UIResponder.keyboardWillShowNotification)
        // THEN
        #expect(bottomConstraint.constant == -TestConfiguration.endFrame.height)
    }

    @Test("View should change bottom inset after keyboard will change frame")
    func viewShouldChangeBottomInsetAfterKeyboardWillChangeFrame() {
        // GIVEN
        let view = UIView()
        let parentView = UIView()
        parentView.addSubview(view)
        let bottomConstraint = parentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let bottomOffset: CGFloat = 20.0
        // WHEN
        let observerToken = KeyboardObserver.addObserver(
            notificationCenter,
            superview: view,
            bottomConstraint: bottomConstraint,
            bottomOffset: bottomOffset,
        )
        _ = observerToken // Avoid unused variable warning
        postTestNotification(name: UIResponder.keyboardWillChangeFrameNotification)
        // THEN
        #expect(bottomConstraint.constant == -TestConfiguration.endFrame.height)
    }

    @Test("View should change bottom inset once after multiple keyboards will appear")
    func viewShouldChangeBottomInsetOnceAfterMultipleKeyboardsWillAppear() {
        // GIVEN
        let view = UIView()
        let parentView = UIView()
        parentView.addSubview(view)
        let bottomConstraint = parentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let bottomOffset: CGFloat = 20.0
        // WHEN
        let observerToken = KeyboardObserver.addObserver(
            notificationCenter,
            superview: view,
            bottomConstraint: bottomConstraint,
            bottomOffset: bottomOffset,
        )
        _ = observerToken // Avoid unused variable warning
        postTestNotification(name: UIResponder.keyboardWillShowNotification)
        postTestNotification(name: UIResponder.keyboardWillShowNotification)
        postTestNotification(name: UIResponder.keyboardWillShowNotification)
        // THEN
        #expect(bottomConstraint.constant == -TestConfiguration.endFrame.height)
    }

    @Test("View should change bottom inset after keyboards will disappear")
    func viewShouldChangeBottomInsetAfterKeyboardsWillDisappear() {
        // GIVEN
        let view = UIView()
        let parentView = UIView()
        parentView.addSubview(view)
        let bottomConstraint = parentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let bottomOffset: CGFloat = 20.0
        // WHEN
        let observerToken = KeyboardObserver.addObserver(
            notificationCenter,
            superview: view,
            bottomConstraint: bottomConstraint,
            bottomOffset: bottomOffset,
        )
        _ = observerToken // Avoid unused variable warning
        postTestNotification(name: UIResponder.keyboardWillHideNotification)
        // THEN
        #expect(bottomConstraint.constant == -bottomOffset)
    }

    @Test("View should change bottom inset once after multiple keyboards will disappear")
    func viewShouldChangeBottomInsetOnceAfterMultipleKeyboardsWillDisappear() {
        // GIVEN
        let view = UIView()
        let parentView = UIView()
        parentView.addSubview(view)
        let bottomConstraint = parentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let bottomOffset: CGFloat = 20.0
        // WHEN
        let observerToken = KeyboardObserver.addObserver(
            notificationCenter,
            superview: view,
            bottomConstraint: bottomConstraint,
            bottomOffset: bottomOffset,
        )
        _ = observerToken // Avoid unused variable warning
        postTestNotification(name: UIResponder.keyboardWillHideNotification)
        postTestNotification(name: UIResponder.keyboardWillHideNotification)
        postTestNotification(name: UIResponder.keyboardWillHideNotification)
        // THEN
        #expect(bottomConstraint.constant == -bottomOffset)
    }

    @Test("View should not change bottom inset after keyboards did appear")
    func viewShouldNotChangeBottomInsetAfterKeyboardsDidAppear() {
        // GIVEN
        let view = UIView()
        let parentView = UIView()
        parentView.addSubview(view)
        let bottomConstraint = parentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let bottomOffset: CGFloat = 20.0
        // WHEN
        let observerToken = KeyboardObserver.addObserver(
            notificationCenter,
            superview: view,
            bottomConstraint: bottomConstraint,
            bottomOffset: bottomOffset,
        )
        _ = observerToken // Avoid unused variable warning
        postTestNotification(name: UIResponder.keyboardDidShowNotification)
        // THEN
        #expect(bottomConstraint.constant == 0)
    }

    @Test("View should not change bottom inset after keyboards did disappear")
    func viewShouldNotChangeBottomInsetAfterKeyboardsDidDisappear() {
        // GIVEN
        let view = UIView()
        let parentView = UIView()
        parentView.addSubview(view)
        let bottomConstraint = parentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let bottomOffset: CGFloat = 20.0
        // WHEN
        let observerToken = KeyboardObserver.addObserver(
            notificationCenter,
            superview: view,
            bottomConstraint: bottomConstraint,
            bottomOffset: bottomOffset,
        )
        _ = observerToken // Avoid unused variable warning
        postTestNotification(name: UIResponder.keyboardDidHideNotification)
        // THEN
        #expect(bottomConstraint.constant == 0)
    }

    @Test("View should not change bottom inset after keyboards did change frame")
    func viewShouldNotChangeBottomInsetAfterKeyboardsDidChangeFrame() {
        // GIVEN
        let view = UIView()
        let parentView = UIView()
        parentView.addSubview(view)
        let bottomConstraint = parentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let bottomOffset: CGFloat = 20.0
        // WHEN
        let observerToken = KeyboardObserver.addObserver(
            notificationCenter,
            superview: view,
            bottomConstraint: bottomConstraint,
            bottomOffset: bottomOffset,
        )
        _ = observerToken // Avoid unused variable warning
        postTestNotification(name: UIResponder.keyboardDidChangeFrameNotification)
        // THEN
        #expect(bottomConstraint.constant == 0)
    }

    @Test("View should not cancel scroll view binding while view binding activated")
    func viewShouldNotCancelScrollViewBindingWhileViewBindingActivated() {
        // GIVEN
        let scrollView = UIScrollView()
        let initialInsets = UIEdgeInsets(top: 10, left: 11, bottom: 12, right: 13)
        scrollView.contentInset = initialInsets

        let view = UIView()
        let parentView = UIView()
        parentView.addSubview(view)
        let bottomConstraint = parentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let bottomOffset: CGFloat = 20.0

        // WHEN
        let anotherToken = KeyboardObserver.addObserver(notificationCenter, scrollView: scrollView)
        _ = anotherToken // Avoid unused variable warning
        let observerToken = KeyboardObserver.addObserver(
            notificationCenter,
            superview: view,
            bottomConstraint: bottomConstraint,
            bottomOffset: bottomOffset,
        )
        _ = observerToken // Avoid unused variable warning
        postTestNotification(name: UIResponder.keyboardWillShowNotification)
        // THEN
        #expect(scrollView.contentInset.bottom == initialInsets.bottom + TestConfiguration.endFrame.height)
        #expect(bottomConstraint.constant == -TestConfiguration.endFrame.height)
    }

    @Test("Data property in event model")
    func dataPropertyInEventModel() {
        // GIVEN
        let frame = KeyboardManagerEvent.Frame(begin: TestConfiguration.beginFrame, end: TestConfiguration.endFrame)
        let data = KeyboardManagerEvent.Data(
            frame: frame,
            animationCurve: TestConfiguration.curve,
            animationDuration: TestConfiguration.animationDuration,
            isLocal: TestConfiguration.isLocal,
        )
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
        #expect(didHideSuccess)
        #expect(willHideSuccess)
        #expect(willShowSuccess)
        #expect(didShowSuccess)
    }
}
