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

import UIKit

/// Keyboard transition metadata object
public enum KeyboardManagerEvent {
    /// UIKeyboardWillShow notification case event
    case willShow(KeyboardManagerEvent.Data)

    /// UIKeyboardDidShow notification case event
    case didShow(KeyboardManagerEvent.Data)

    /// UIKeyboardWillHide notification case event
    case willHide(KeyboardManagerEvent.Data)

    /// UIKeyboardDidHide notification case event
    case didHide(KeyboardManagerEvent.Data)

    /// UIKeyboardWillChangeFrame notification case event
    case willFrameChange(KeyboardManagerEvent.Data)

    /// UIKeyboardDidChangeFrame notification case event
    case didFrameChange(KeyboardManagerEvent.Data)

    // MARK: Nested Types

    /// `UIKeyboardFrameBeginUserInfoKey` and `UIKeyboardFrameEndUserInfoKey` values
    public struct Frame {
        /// Begin transition keyboard frame
        public var begin: CGRect

        /// Final transition keyboard frame
        public var end: CGRect
    }

    /// Notification `userInfo` metadata info
    public struct Data {
        // MARK: Properties

        /// Keyboard frames
        public var frame: Frame

        /// Animation curve value
        public var animationCurve: Int

        /// Transition animation duration value
        public var animationDuration: Double

        /// `UIKeyboardIsLocalUserInfoKey` `userInfo` value
        public var isLocal: Bool

        // MARK: Static Functions

        static func null() -> Data {
            let frame = Frame(begin: CGRect.zero, end: CGRect.zero)
            return Data(frame: frame, animationCurve: 0, animationDuration: 0.0, isLocal: false)
        }
    }

    // MARK: Computed Properties

    var data: KeyboardManagerEvent.Data {
        switch self {
        case let .willShow(data),
             let .didShow(data),
             let .willHide(data),
             let .didHide(data),
             let .willFrameChange(data),
             let .didFrameChange(data):
            data
        }
    }
}
