//
//  LastKeyboardEventStorage.swift
//  KeyboardManager
//
//  Created by Vlad Zaicev on 07.06.2021.
//

import Foundation

final class LastKeyboardEventStorage {
    private init() {
        token = KeyboardObserver.addObserver(.default) { event in
            self.event = event
        }
    }

    deinit {
        token = nil
    }

    static let shared = LastKeyboardEventStorage()

    public static var lastEvent: KeyboardManagerEvent? {
        shared.event
    }

//    public static func initEventObserver(notificationCenter: NotificationCenter = .default) {
//        shared.token = KeyboardObserver.addObserver(notificationCenter, { event in
//            shared.event = event
//        })
//    }

    private var token: KeyboardObserverToken?
    private var event: KeyboardManagerEvent?
}
