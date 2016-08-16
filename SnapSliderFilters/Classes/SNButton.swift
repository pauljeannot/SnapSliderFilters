//
//  SNButton.swift
//  Pods
//
//  Created by Paul Jeannot on 15/08/2016.
//
//

import UIKit

public class SNButton: UIButton {
    
    public typealias actionTypeClosure = () -> ()
    private var action:actionTypeClosure = {}
    
    private var shouldRunAction = false
    private var _buttonState = ButtonAnimationState.smallButton
    private var buttonState:ButtonAnimationState  {
        get {
            return _buttonState
        }
        set (newValue) {
            // The button is pressed : starting the animation to make it big
            if buttonState == .smallButton && newValue == .bigButton {
                UIView.animateWithDuration(0.15,
                                           animations: {
                                            self.transform = ButtonAnimations.animationButtonPressed
                                            self._buttonState = .animating
                    },
                                           completion: { _ in
                                            // Now it is big :
                                            // Button already released : make it small
                                            if self._buttonState == .smallButton {
                                                self.buttonState = .smallButton
                                            }
                                                // Button still pressed : bounce effect
                                            else {
                                                UIView.animateWithDuration(0.09,
                                                    animations: {
                                                        self.transform = ButtonAnimations.animationButtonPressedSmallBounce
                                                    },
                                                    completion: { _ in
                                                        // Boune effect completed : if button not released : stay big
                                                        if self._buttonState == .animating {
                                                            self._buttonState = .bigButton
                                                        }
                                                            // If released : make it small
                                                        else if self._buttonState == .smallButton {
                                                            self.buttonState = .smallButton
                                                        }
                                                    }
                                                )
                                            }
                    }
                )
            }
                // The button is released when it was big || during the animation : make it small again
            else if _buttonState == .bigButton && newValue == .smallButton || _buttonState == .smallButton && newValue == .smallButton {
                if shouldRunAction {
                    shouldRunAction = false
                    self.action()
                }
                UIView.animateWithDuration(0.15,
                                           animations: {
                                            self.transform = ButtonAnimations.animationButtonReleased
                                            self._buttonState = .animating
                    },
                                           completion: { _ in
                                            self._buttonState = .smallButton
                    }
                )
            }
                // The button is released during the animation : make it small
            else if buttonState == .animating && newValue == .smallButton {
                self._buttonState = .smallButton
            }
        }
    }
    
    private struct ButtonAnimations {
        static let animationButtonPressed = CGAffineTransformMakeScale(1.25, 1.25)
        static let animationButtonPressedSmallBounce = CGAffineTransformMakeScale(1.13, 1.13)
        static let animationButtonReleased = CGAffineTransformMakeScale(1, 1)
    }
    
    private enum ButtonAnimationState {
        case animating      // If the animation is running
        case smallButton    // If the button is/is wanted small
        case bigButton      // If the button is/is wanted big
    }
    
    public init(frame: CGRect, withImageNamed name: String) {
        super.init(frame: CGRect(x: frame.origin.x - 10, y: frame.origin.y - 20, width: frame.size.width+20, height: frame.size.height+20))
        
        self.layer.zPosition = 1000
        self.adjustsImageWhenHighlighted = false
        self.setImage(UIImage(named: name), forState: .Normal)
        self.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        
        self.addTarget(self, action: #selector(buttonTouchUpInside), forControlEvents: .TouchUpInside)
        self.addTarget(self, action: #selector(buttonPressed), forControlEvents: .TouchDown)
        self.addTarget(self, action: #selector(buttonPressed), forControlEvents: .TouchDragEnter)
        self.addTarget(self, action: #selector(buttonPressed), forControlEvents: .TouchDragInside)
        self.addTarget(self, action: #selector(buttonReleased), forControlEvents: .TouchDragExit)
        self.addTarget(self, action: #selector(buttonReleased), forControlEvents: .TouchCancel)
        self.addTarget(self, action: #selector(buttonReleased), forControlEvents: .TouchDragOutside)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setAction(action actionClosure: actionTypeClosure) {
        self.action = actionClosure
    }
    
    func buttonTouchUpInside() {
        shouldRunAction=true
        buttonReleased()
    }
    
    func buttonPressed() {
        buttonState = .bigButton
    }
    
    func buttonReleased() {
        buttonState = .smallButton
    }
}
