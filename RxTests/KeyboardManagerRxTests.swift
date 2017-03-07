//
//  KeyboardManagerRxTests.swift
//  KeyboardManagerRxTests
//
//  Created by Alexey Korolev on 06.03.17.
//  Copyright © 2017 Alexey Korolev. All rights reserved.
//

import XCTest
import RxSwift
@testable import KeyboardManager
@testable import KeyboardManagerRx

class RxKeyboardManagerTests: XCTestCase {

    let disposeBag = DisposeBag()
    var keyboardManagerMock: KeyboardManagerProtocol!
    var keyboardManagerRx: RxKeyboardManagerProtocol!

    override func setUp() {
        super.setUp()
        keyboardManagerMock = KeyboardManagerMock()
        keyboardManagerRx = RxKeyboardManager(keyboardManager: keyboardManagerMock)
    }

    override func tearDown() {
        super.tearDown()
        keyboardManagerRx = nil
        keyboardManagerMock = nil
    }

    func testReceiveDataFromObservableAfterTriggerClosureEvent() {
        var received = false
        keyboardManagerRx
                .newEventObserver
                .subscribe(onNext: { event, _ in
                    if case .willShow = event {
                        received = true
                    }
                })
                .addDisposableTo(disposeBag)

        keyboardManagerMock.eventClosure!(.willShow, KeyboardManagerEventData.null())
        XCTAssertTrue(received, "new value not received")
    }
}

class KeyboardManagerMock: KeyboardManagerProtocol {
    var eventClosure: KeyboardManagerEventClosure?
}
