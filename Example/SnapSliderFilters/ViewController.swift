//
//  ViewController.swift
//  SnapSliderFilters
//
//  Created by Paul Jeannot on 05/04/2016.
//  Copyright (c) 2016 Paul Jeannot. All rights reserved.
//

import UIKit
import SnapSliderFilters

class ViewController: UIViewController {
    
    // The screenView will be the screenshoted view : all its subviews will appear on it (so, don't add buttons in its subviews)
    private let screenView:UIView = UIView(frame: CGRect(origin: CGPointZero, size: SNUtils.screenSize))
    private let slider:SNSlider = SNSlider(frame: CGRect(origin: CGPointZero, size: SNUtils.screenSize))
    private let textField = SNTextField(y: SNUtils.screenSize.height/2, width: SNUtils.screenSize.width, heightOfScreen: SNUtils.screenSize.height)
    private let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer()
    private let buttonSave = SNButton(frame: CGRect(x: 20, y: SNUtils.screenSize.height - 35, width: 33, height: 30), withImageNamed: "saveButton")
    private let buttonCamera = SNButton(frame: CGRect(x: 75, y: SNUtils.screenSize.height - 42, width: 45, height: 45), withImageNamed: "galleryButton")
    private let imagePicker = UIImagePickerController()
    private var data:[SNFilter] = []
    
    //MARK: Overriden functions
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGesture.addTarget(self, action: #selector(handleTap))
        
        setupSlider()
        setupTextField()
        view.addSubview(screenView)        
        setupButtonSave()
        setupButtonCamera()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(textField)
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.setAnimationsEnabled(true)
    }
    
    //MARK: Setup
    private func setupSlider() {
        self.createData(UIImage(named: "pic")!)
        self.slider.dataSource = self
        self.slider.userInteractionEnabled = true
        self.slider.multipleTouchEnabled = true
        self.slider.exclusiveTouch = false
        
        self.screenView.addSubview(slider)
        self.slider.reloadData()
    }
    
    private func setupTextField() {
        self.screenView.addSubview(textField)
        
        self.tapGesture.delegate = self
        self.slider.addGestureRecognizer(tapGesture)
        
        NSNotificationCenter.defaultCenter().addObserver(self.textField, selector: #selector(SNTextField.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self.textField, selector: #selector(SNTextField.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self.textField, selector: #selector(SNTextField.keyboardTypeChanged(_:)), name: UIKeyboardDidShowNotification, object: nil)
    }
    
    private func setupButtonSave() {
        self.buttonSave.setAction {
            [weak weakSelf = self] in
            let picture = SNUtils.screenShot(weakSelf?.screenView)
            if let image = picture {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
        }
        
        self.view.addSubview(self.buttonSave)
    }
    
    private func setupButtonCamera() {
        self.buttonCamera.setAction {
            [weak weakSelf = self] in
            
            if let tmpImagePicker = weakSelf?.imagePicker {
                tmpImagePicker.allowsEditing = false
                tmpImagePicker.sourceType = .PhotoLibrary
                
                weakSelf?.presentViewController(tmpImagePicker, animated: true, completion: nil)
            }
        }
        
        imagePicker.delegate = self
        self.view.addSubview(self.buttonCamera)
    }
    
    //MARK: Functions
    private func createData(image: UIImage) {
        self.data = SNFilter.generateFilters(SNFilter(frame: self.slider.frame, withImage: image), filters: SNFilter.filterNameList)
        
        self.data[1].addSticker(SNSticker(frame: CGRect(x: 195, y: 30, width: 90, height: 90), image: UIImage(named: "stick2")!))
        self.data[2].addSticker(SNSticker(frame: CGRect(x: 30, y: 100, width: 250, height: 250), image: UIImage(named: "stick3")!))
        self.data[3].addSticker(SNSticker(frame: CGRect(x: 20, y: 00, width: 140, height: 140), image: UIImage(named: "stick")!))
    }
    
    private func updatePicture(newImage: UIImage) {
        createData(newImage)
        slider.reloadData()
    }
}

//MARK: - Extension SNSlider DataSource

extension ViewController: SNSliderDataSource {
    
    func numberOfSlides(slider: SNSlider) -> Int {
        return data.count
    }
    
    func slider(slider: SNSlider, slideAtIndex index: Int) -> SNFilter {
        
        return data[index]
    }
    
    func startAtIndex(slider: SNSlider) -> Int {
        return 0
    }
}

//MARK: - Extension Gesture Recognizer Delegate and touch Handler for TextField

extension ViewController: UIGestureRecognizerDelegate {
    
    func handleTap() {
        self.textField.handleTap()
    }
}

// MARK: - UIImagePickerControllerDelegate Methods

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            // To avoid too big images and orientation issue
            let newImage = pickedImage.resizeWithWidth(SNUtils.screenSize.width)
            if let image = newImage {
                updatePicture(image)
            }
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}