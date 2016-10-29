//
//  SNTextField.swift
//  Pods
//
//  Created by Paul Jeannot on 04/05/2016.
//
//

import UIKit

open class SNTextField: UITextField {
    
    var location:CGPoint
    var panGesture:UIPanGestureRecognizer = UIPanGestureRecognizer()
    var heightOfScreen:CGFloat
    
    public init(y: CGFloat, width: CGFloat, heightOfScreen height: CGFloat) {
        
        self.location = CGPoint(x: 0, y: y)
        self.heightOfScreen = height
        
        super.init(frame: CGRect(x: 0, y: y, width: width, height: 40))
        self.layer.zPosition = 100
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.45)
        self.tintColor = UIColor.white
        self.textColor = UIColor.white
        self.placeholder = ""
        self.font = UIFont.systemFont(ofSize: 16)
        self.borderStyle = UITextBorderStyle.none
        self.autocorrectionType = UITextAutocorrectionType.no
        self.keyboardType = UIKeyboardType.default
        self.returnKeyType = UIReturnKeyType.done
        self.clearButtonMode = UITextFieldViewMode.never;
        self.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        self.textAlignment = .center
        self.contentHorizontalAlignment = .center
        self.delegate = self
        self.isHidden = true
        
        panGesture = UIPanGestureRecognizer(target:self, action: #selector(SNTextField.handlePan(_:)))
        panGesture.delegate = self
        self.addGestureRecognizer(panGesture)
    }
    
    fileprivate func show() {
        self.isHidden = false
    }
    
    fileprivate func hideKeyboard() {
        self.resignFirstResponder();
    }
    
    fileprivate func showKeyboard() {
        self.becomeFirstResponder();
    }
    
    fileprivate func touchMoved(_ position: CGPoint) {
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UITextField Delegate

extension SNTextField: UITextFieldDelegate {
    
    // If the TextField is empty, it's hidden
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if (self.text == "") {
            self.isHidden = true
        }
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true;
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    
    // Limit the text size to the screen width
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text:NSString = (self.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        let contentWidth = text.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16.0)]).width
        return contentWidth <= (self.frame.width - 20)
    }
    
    // Hide the keyboard
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true;
    }
}

//MARK: - Extension Gesture Recognizer Delegate and touch handler for TextField

extension SNTextField: UIGestureRecognizerDelegate {
    
    public func handleTap() {
        if(self.isHidden == true) {
            self.show()
            self.showKeyboard()
        }
        else {
            self.hideKeyboard()
        }
    }
    
    func handlePan(_ recognizer:UIPanGestureRecognizer) {
        
        if self.isFirstResponder == true { return }
        
        let position = panGesture.location(in: self)
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
    
    func keyboardWillShow(_ notification: Notification) {
        updatePosition(notification)
    }
    
    func keyboardTypeChanged(_ notification: Notification) {
        updatePosition(notification)
    }
    
    func keyboardWillHide(_ notification: Notification) {
        self.frame.origin.y = self.location.y
    }
    
    func updatePosition(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.frame.origin.y = self.heightOfScreen - keyboardSize.height - self.frame.size.height
        }
    }
}
