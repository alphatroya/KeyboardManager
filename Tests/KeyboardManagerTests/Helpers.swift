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
