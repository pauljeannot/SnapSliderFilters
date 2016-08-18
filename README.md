# SnapSliderFilters

[![Version](https://img.shields.io/cocoapods/v/SnapSliderFilters.svg?style=flat)](http://cocoapods.org/pods/SnapSliderFilters)
[![License](https://img.shields.io/cocoapods/l/SnapSliderFilters.svg?style=flat)](http://cocoapods.org/pods/SnapSliderFilters)
[![Platform](https://img.shields.io/cocoapods/p/SnapSliderFilters.svg?style=flat)](http://cocoapods.org/pods/SnapSliderFilters)

SnapSliderFilters allows you to create easily a SnapChat like navigation between a picture and its filters (that you can automatically generate). You can add stickers above the slides, tap on the screen to add a message and place it wherever you want, exactly as you do every day on SnapChat !

![Gif example 1](https://media.giphy.com/media/l0K4a2gNdOxrMH3Tq/giphy.gif)
![Gif example 2](https://media.giphy.com/media/26FxxUyEKHtLQHwrK/giphy.gif)

## Installation with CocoaPods

SnapSliderFilters is available through [CocoaPods](http://cocoapods.org). To install
it, add the following line to your Podfile:

```ruby
pod "SnapSliderFilters"
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
This demo allows you to import your own images from the camera roll and to save the final edited one.

## Requirements

#### Platform

- Swift 2
- Xcode 7
- iOS 9

#### Supported Device

iPhone 4s, 5, 5s, 5c, 6, 6 Plus, 6s, 6s Plus, all iPad having iOS 9.

## How to use

### Slider

To insert a slider in your ViewController, all you need is to create the slider, load the data and show it.

The slider **must** be in displayed in fullscreen. `SNUtils` allows you to do it easily :
```swift
var slider = SNSlider(frame: CGRect(origin: CGPointZero, size: SNUtils.screenSize))
```

Then, you can generate filters from your original picture, using the [Core Image Filter](https://developer.apple.com/library/mac/documentation/GraphicsImaging/Reference/CoreImageFilterReference/). `SNFilter.filterNameList`is a small selection of filters that you can use for a quick demo :
```swift 
// Create your original filter
var originalPicture = SNFilter(frame: slider.frame, withImage: UIImage(named: "yourPicture")!)
// Generate differents filters by passing in argument the original picture and an array of filter's name
var data  = SNFilter.generateFilters(originalPicture, filters: SNFilter.filterNameList)
```

You can add some stickers above your filters, by creating a `SNSticker` and adding it to the proper filter :
```swift
var sticker = SNSticker(frame: CGRect(x: 20, y: 0, width: 140, height: 140), image: UIImage(named: "stick")!)
// In case of overlapping, you can provide a zPosition (the default one is 0)
var sticker2 = SNSticker(frame: CGRect(x: 30, y: 0, width: 140, height: 140), image: UIImage(named: "stick")!, atZPosition: 2))

// 2 stickers will be added to the filter at index 1
self.data[1].addSticker(sticker)
self.data[1].addSticker(sticker2)
```

Your ViewController must conform to the `SNSliderDataSource` protocol. It allows the slider to be populated with your own data.

```swift
extension ViewController: SNSliderDataSource {

  // The number of SNFilters that you want in the slider
  func numberOfSlides(slider: SNSlider) -> Int {
    return data.count
  }

  // For a given index, you return the corresponding SNFilter
  func slider(slider: SNSlider, slideAtIndex index: Int) -> SNFilter {
    return data[index]
  }

  // The starting index of the slider
  func startAtIndex(slider: SNSlider) -> Int {
    return 0
  }
}
```

Finally, you can show the slider :

```swift 
slider.dataSource = self
slider.userInteractionEnabled = true
view.addSubview(slider)
slider.reloadData()
```

### TextField

If you want to add a Snapchat like textfield above your slider, your can do it easily as well. Firstly, create the `SNTextField` : all you need to pass is your `y` starting point for the textfield, the width and the height of your screen (once again, `SNUtils` helps you in this case).

```swift
var textfield = SNTextField(y: SNUtils.screenSize.height/2, width: SNUtils.screenSize.width, heightOfScreen: SNUtils.screenSize.height)
```

Make sure to put it above all your views by adding it to just after the initialization, and then show it :
```swift 
textField.layer.zPosition = 100
self.view.addSubview(textField)
```

Now a little bit of boilerplate code, to create observers for the keyboard behaviour and to detect the tap gesture :
```swift 
var tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
tapGesture.delegate = self
slider.addGestureRecognizer(tapGesture)

NSNotificationCenter.defaultCenter().addObserver(self.textField, selector: #selector(SNTextField.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
NSNotificationCenter.defaultCenter().addObserver(self.textField, selector: #selector(SNTextField.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
NSNotificationCenter.defaultCenter().addObserver(self.textField, selector: #selector(SNTextField.keyboardTypeChanged(_:)), name: UIKeyboardDidShowNotification, object: nil)
```

You ViewController must conform to the `UIGestureRecognizerDelegate`. Add this extension at the end of your file :

```swift 
extension ViewController: UIGestureRecognizerDelegate {

  func handleTap() {
    self.textField.handleTap()
  }
}
```

Finally, do not forget to remove observers :
```swift
override func viewWillDisappear(animated: Bool) {
  NSNotificationCenter.defaultCenter().removeObserver(textField)
}
```

### Get the final-edited image

```swift
let picture = SNUtils.screenShot(self.view)
```

## Author

Paul Jeannot, Computer Science & Engineering student at University of Technology of Compiègne.
Contact at paul.jeannot95@gmail.com

## License

Free Icons provided by [Icons8](https://icons8.com)

SnapSliderFilters is available under the MIT license. See the LICENSE file for more info.
