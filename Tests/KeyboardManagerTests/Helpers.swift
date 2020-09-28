//
// KeyboardManager on 05.05.2020
// Copyright © 2020 Alexey Korolev <alphatroya@gmail.com>
//

import KeyboardManager
import UIKit

extension KeyboardManagerTests {
    func postTestNotification(name: Notification.Name) {
        notificationCenter.post(name: name, object: nil, userInfo: [
            UIResponder.keyboardFrameEndUserInfoKey: NSValue(cgRect: endFrame),
            UIResponder.keyboardFrameBeginUserInfoKey: NSValue(cgRect: beginFrame),
            UIResponder.keyboardAnimationDurationUserInfoKey: animationDuration,
            UIResponder.keyboardIsLocalUserInfoKey: isLocal,
            UIResponder.keyboardAnimationCurveUserInfoKey: curve,
        ])
    }

    func postWrongTestNotification() {
        notificationCenter.post(name: UIResponder.keyboardDidShowNotification, object: nil, userInfo: [
            UIResponder.keyboardFrameEndUserInfoKey: NSValue(cgRect: endFrame),
            UIResponder.keyboardAnimationCurveUserInfoKey: 10,
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
