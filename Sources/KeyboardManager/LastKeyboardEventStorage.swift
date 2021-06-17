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

import Foundation

/// Singletone storage for last keyboard transition metadata object
public final class LastKeyboardEventStorage {
    init(notificationCenter: NotificationCenter = .default) {
        token = KeyboardObserver.addObserver(notificationCenter) { [weak self] event in
            self?.event = event
        }
    }

    /// Init this instance as early as possible for start keyboard event observer
    public static let shared = LastKeyboardEventStorage()

    /// Last registered keyboard transition metadata object
    public var lastEvent: KeyboardManagerEvent? {
        event
    }

    private var token: KeyboardObserverToken?
    private var event: KeyboardManagerEvent?
}
