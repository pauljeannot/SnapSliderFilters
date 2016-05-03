//
//  SNTextField.swift
//  Pods
//
//  Created by Paul Jeannot on 04/05/2016.
//
//

import UIKit

public class SNTextField: UITextField {
    
    var location:CGPoint
    var panGesture:UIPanGestureRecognizer = UIPanGestureRecognizer()
    var heightOfScreen:CGFloat
    
    public init(y: CGFloat, width: CGFloat, heightOfScreen height: CGFloat) {
        
        self.location = CGPoint(x: 0, y: y)
        self.heightOfScreen = height
        
        super.init(frame: CGRect(x: 0, y: y, width: width, height: 40))
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.45)
        self.tintColor = UIColor.whiteColor()
        self.textColor = UIColor.whiteColor()
        self.placeholder = ""
        self.font = UIFont.systemFontOfSize(16)
        self.borderStyle = UITextBorderStyle.None
        self.autocorrectionType = UITextAutocorrectionType.No
        self.keyboardType = UIKeyboardType.Default
        self.returnKeyType = UIReturnKeyType.Done
        self.clearButtonMode = UITextFieldViewMode.Never;
        self.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        self.textAlignment = .Center
        self.contentHorizontalAlignment = .Center
        self.delegate = self
        self.hidden = true
        
        panGesture = UIPanGestureRecognizer(target:self, action: #selector(SNTextField.handlePan(_:)))
        panGesture.delegate = self
        self.addGestureRecognizer(panGesture)
    }
    
    func show() {
        self.hidden = false
    }
    
    func hideKeyboard() {
        self.resignFirstResponder();
    }
    
    func showKeyboard() {
        self.becomeFirstResponder();
    }
    
    func touchMoved(position: CGPoint) {
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UITextField Delegate

extension SNTextField: UITextFieldDelegate {
    
    // If the TextField is empty, it's hidden
    public func textFieldDidEndEditing(textField: UITextField) {
        if (self.text == "") {
            self.hidden = true
        }
    }
    
    public func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true;
    }
    
    public func textFieldShouldClear(textField: UITextField) -> Bool {
        return true;
    }
    
    public func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true;
    }
    
    // Limit the text size to the screen width
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let text:NSString = (self.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        let contentWidth = text.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(16.0)]).width
        return contentWidth <= (self.frame.width - 20)
    }
    
    // Hide the keyboard
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        hideKeyboard()
        return true;
    }
}

//MARK: - Extension Gesture Recognizer Delegate and touch Handler for TextField
extension SNTextField: UIGestureRecognizerDelegate {
    
    public func handleTap() {
        if(self.hidden == true) {
            self.show()
            self.showKeyboard()
        }
        else {
            self.hideKeyboard()
        }
    }
    
    func handlePan(recognizer:UIPanGestureRecognizer) {
        let position = panGesture.locationInView(self)
        let tempLocation = location.y + position.y
        
        if (tempLocation < 0) {
            location.y = 0
            self.frame.origin.y = location.y
        }
        else if (tempLocation > heightOfScreen-self.frame.size.height) {
            location.y = heightOfScreen-self.frame.size.height
            self.frame.origin.y = heightOfScreen-self.frame.size.height
        }
        else {
            location.y = tempLocation
            self.frame.origin.y = tempLocation
        }
    }
}

//MARK: - Extension to handle Keyboard Behaviour

public extension SNTextField {
    
    func keyboardWillShow(notification: NSNotification) {
        updatePosition(notification)
    }
    
    func keyboardTypeChanged(notification: NSNotification) {
        updatePosition(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.frame.origin.y = self.location.y
    }
    
    func updatePosition(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            self.frame.origin.y = self.heightOfScreen - keyboardSize.height - self.frame.size.height
        }
    }
}