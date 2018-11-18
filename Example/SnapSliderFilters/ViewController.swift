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
    fileprivate let screenView:UIView = UIView(frame: CGRect(origin: CGPoint.zero, size: SNUtils.screenSize))
    fileprivate let slider:SNSlider = SNSlider(frame: CGRect(origin: CGPoint.zero, size: SNUtils.screenSize))
    fileprivate let textField = SNTextField(y: SNUtils.screenSize.height/2, width: SNUtils.screenSize.width, heightOfScreen: SNUtils.screenSize.height)
    fileprivate let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer()
    fileprivate let buttonSave = SNButton(frame: CGRect(x: 20, y: SNUtils.screenSize.height - 35, width: 33, height: 30), withImageNamed: "saveButton")
    fileprivate let buttonCamera = SNButton(frame: CGRect(x: 75, y: SNUtils.screenSize.height - 42, width: 45, height: 45), withImageNamed: "galleryButton")
    fileprivate let imagePicker = UIImagePickerController()
    fileprivate var data:[SNFilter] = []
    
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
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.isStatusBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(textField)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.setAnimationsEnabled(true)
    }
    
    //MARK: Setup
    fileprivate func setupSlider() {
        self.createData(UIImage(named: "pic")!)
        self.slider.dataSource = self
        self.slider.isUserInteractionEnabled = true
        self.slider.isMultipleTouchEnabled = true
        self.slider.isExclusiveTouch = false
        
        self.screenView.addSubview(slider)
        self.slider.reloadData()
    }
    
    fileprivate func setupTextField() {
        self.screenView.addSubview(textField)
        
        self.tapGesture.delegate = self
        self.slider.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self.textField, selector: #selector(SNTextField.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self.textField, selector: #selector(SNTextField.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self.textField, selector: #selector(SNTextField.keyboardTypeChanged(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    }
    
    fileprivate func setupButtonSave() {
        self.buttonSave.setAction {
            [weak weakSelf = self] in
            let picture = SNUtils.screenShot(weakSelf?.screenView)
            if let image = picture {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
        }
        
        self.view.addSubview(self.buttonSave)
    }
    
    fileprivate func setupButtonCamera() {
        self.buttonCamera.setAction {
            [weak weakSelf = self] in
            
            if let tmpImagePicker = weakSelf?.imagePicker {
                tmpImagePicker.allowsEditing = false
                tmpImagePicker.sourceType = .photoLibrary
                
                weakSelf?.present(tmpImagePicker, animated: true, completion: nil)
            }
        }
        
        imagePicker.delegate = self
        self.view.addSubview(self.buttonCamera)
    }
    
    //MARK: Functions
    fileprivate func createData(_ image: UIImage) {
        self.data = SNFilter.generateFilters(SNFilter(frame: self.slider.frame, withImage: image), filters: SNFilter.filterNameList)
        
        self.data[1].addSticker(SNSticker(frame: CGRect(x: 195, y: 30, width: 90, height: 90), image: UIImage(named: "stick2")!))
        self.data[2].addSticker(SNSticker(frame: CGRect(x: 30, y: 100, width: 250, height: 250), image: UIImage(named: "stick3")!))
        self.data[3].addSticker(SNSticker(frame: CGRect(x: 20, y: 00, width: 140, height: 140), image: UIImage(named: "stick")!))
    }
    
    fileprivate func updatePicture(_ newImage: UIImage) {
        createData(newImage)
        slider.reloadData()
    }
}

//MARK: - Extension SNSlider DataSource

extension ViewController: SNSliderDataSource {
    
    func numberOfSlides(_ slider: SNSlider) -> Int {
        return data.count
    }
    
    func slider(_ slider: SNSlider, slideAtIndex index: Int) -> SNFilter {
        
        return data[index]
    }
    
    func startAtIndex(_ slider: SNSlider) -> Int {
        return 0
    }
}

//MARK: - Extension Gesture Recognizer Delegate and touch Handler for TextField

extension ViewController: UIGestureRecognizerDelegate {
    
    @objc func handleTap() {
        self.textField.handleTap()
    }
}

// MARK: - UIImagePickerControllerDelegate Methods

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            // To avoid too big images and orientation issue
            let newImage = pickedImage.resizeWithWidth(SNUtils.screenSize.width)
            if let image = newImage {
                updatePicture(image)
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
