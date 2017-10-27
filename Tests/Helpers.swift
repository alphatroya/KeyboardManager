//
// Created by Alexey Korolev on 25.10.2017.
// Copyright (c) 2017 Alexey Korolev. All rights reserved.
//

import UIKit
import KeyboardManager

extension KeyboardManagerTests {

    func postTestNotification(name: Notification.Name) {
        notificationCenter.post(name: name, object: nil, userInfo: [
            UIKeyboardFrameEndUserInfoKey: NSValue(cgRect: endFrame),
            UIKeyboardFrameBeginUserInfoKey: NSValue(cgRect: beginFrame),
            UIKeyboardAnimationDurationUserInfoKey: animationDuration,
            UIKeyboardIsLocalUserInfoKey: isLocal,
            UIKeyboardAnimationCurveUserInfoKey: curve,
        ])
    }

    func postWrongTestNotification() {
        notificationCenter.post(name: Notification.Name.UIKeyboardDidShow, object: nil, userInfo: [
            UIKeyboardFrameEndUserInfoKey: NSValue(cgRect: endFrame),
            UIKeyboardAnimationCurveUserInfoKey: 10,
        ])
    }

    func compareWithTestData(another data: KeyboardManagerEvent.Data) -> Bool {
        let isFrameEqual = data.frame.begin == beginFrame &&
            data.frame.end == endFrame
        return isFrameEqual &&
            data.animationDuration == animationDuration &&
            data.animationCurve == curve &&
            data.isLocal == isLocal
    }

    func compare(lhs: KeyboardManagerEvent.Data, rhs: KeyboardManagerEvent.Data) -> Bool {
        return lhs.animationCurve == rhs.animationCurve &&
            lhs.animationDuration == rhs.animationDuration &&
            lhs.isLocal == rhs.isLocal &&
            lhs.frame.begin == rhs.frame.begin &&
            lhs.frame.end == rhs.frame.end
    }
}
