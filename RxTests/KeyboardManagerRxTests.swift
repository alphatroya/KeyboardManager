//
//  KeyboardManagerRxTests.swift
//  KeyboardManagerRxTests
//
//  Created by Alexey Korolev on 06.03.17.
//  Copyright © 2017 Alexey Korolev. All rights reserved.
//

import Quick
import RxSwift
@testable import KeyboardManager
@testable import KeyboardManagerRx

class KeyboardManagerRx: QuickSpec {
    override func spec() {
        let disposeBag = DisposeBag()
        var keyboardManagerMock: KeyboardManagerProtocol!
        var keyboardManagerRx: RxKeyboardManagerProtocol!
        beforeEach {
            keyboardManagerMock = KeyboardManagerMock()
            keyboardManagerRx = RxKeyboardManager(keyboardManager: keyboardManagerMock)
        }
        afterEach {
            keyboardManagerRx = nil
            keyboardManagerMock = nil
        }
        it("receive data from observable after event closure was triggered") {
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
}

class KeyboardManagerMock: KeyboardManagerProtocol {
    var eventClosure: KeyboardManagerEventClosure?
}
