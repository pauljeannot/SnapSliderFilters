#
# Be sure to run `pod lib lint SnapSliderFilters.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SnapSliderFilters"
  s.version          = "0.1.0"
  s.summary          = "SnapSliderFilters allows you to create easily a SnapChat like navigation between a picture and its filters (automatically generated). You can add stickers above slides, tap on the screen to add a message and place it where you want, exactly as you do every day on SnapChat !"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = "https://github.com/<GITHUB_USERNAME>/SnapSliderFilters"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Paul Jeannot" => "paul.jeannot@etu.utc.fr" }
  s.source           = { :git => "https://github.com/pauljeannot/SnapSliderFilters.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SnapSliderFilters/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SnapSliderFilters' => ['SnapSliderFilters/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
