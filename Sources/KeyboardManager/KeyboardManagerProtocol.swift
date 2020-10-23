//
// KeyboardManager on 23.10.2020
// Copyright © 2020 Alexey Korolev <alphatroya@gmail.com>
//

import UIKit

/**
 Protocol defines an interface for keyboard manager
 */
public protocol KeyboardManagerProtocol: AnyObject {
    /// New keyboard events observer
    var eventClosure: KeyboardManagerEventClosure? { get set }

    /**
     Helper method that automatically adjusts scrollView's contentInset property
     with animation after receive keyboard will appear and will hide notifications.

     - parameter scrollView: UIScrollView instance, that will be modified after notifications emerged
     */
    func bindToKeyboardNotifications(scrollView: UIScrollView)

    /**
     Helper method that automatically adjusts view's bottom constraint after receiving keyboard appear notifications

     - parameter superview: UIView instance, that will be layout after contraint adjust, basically the superview of the scene
     - parameter bottomConstraint: contraint instance that `constant` property will be adjusted
     - parameter bottomOffset: minimal offset value that will be preserved after keyboard disappeared
     - parameter animated: should changes be animated
     */
    func bindToKeyboardNotifications(
        superview: UIView,
        bottomConstraint: NSLayoutConstraint,
        bottomOffset: CGFloat,
        animated: Bool
    )
}

public extension KeyboardManagerProtocol {
    func bindToKeyboardNotifications(
        superview: UIView,
        bottomConstraint: NSLayoutConstraint,
        bottomOffset: CGFloat = 0.0,
        animated _: Bool = false
    ) {
        bindToKeyboardNotifications(superview: superview, bottomConstraint: bottomConstraint, bottomOffset: bottomOffset, animated: false)
    }
}
