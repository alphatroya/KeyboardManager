//
// Created by Alexey Korolev on 27.02.17.
// Copyright (c) 2017 Alexey Korolev. All rights reserved.
//

import Foundation
import RxSwift
import KeyboardManager

public protocol RxKeyboardManagerProtocol {
    var newEventObserver: Observable<(KeyboardManagerEvent, KeyboardManagerEventData)> { get }
}

public class RxKeyboardManager {

    fileprivate var keyboardManager: KeyboardManagerProtocol
    fileprivate let eventObserverSubject = PublishSubject<(KeyboardManagerEvent, KeyboardManagerEventData)>()
    public init(keyboardManager: KeyboardManagerProtocol) {
        self.keyboardManager = keyboardManager
        self.keyboardManager.eventClosure = { [unowned self] event, data in
            self.eventObserverSubject.onNext((event, data))
        }
    }
}

extension RxKeyboardManager: RxKeyboardManagerProtocol {
    public var newEventObserver: Observable<(KeyboardManagerEvent, KeyboardManagerEventData)> {
        return eventObserverSubject.asObserver()
    }
}
