#
# Be sure to run `pod lib lint GMPhoneInfo.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GMPhoneInfo'
  s.version          = '0.1.0'
  s.summary          = 'A short description of GMPhoneInfo.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/ioszhanghui@163.com/GMPhoneInfo'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ioszhanghui@163.com' => 'yomingyo@gmail.com' }
  s.source           = { :git => 'https://github.com/ioszhanghui@163.com/GMPhoneInfo.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'GMPhoneInfo/Classes/**/*'

    s.subspec 'AppInfo' do |aa|
        aa.source_files ='GMPhoneInfo/Classes/AppInfo/**/*'
        aa.frameworks = 'CoreLocation','AddressBook','Contacts','Photos','AVFoundation'
        aa.requires_arc = true
    end
    s.subspec 'DeviceInfo' do |bb|
        bb.source_files ='GMPhoneInfo/Classes/DeviceInfob/**/*'
        bb.frameworks = 'AdSupport'
        bb.requires_arc = true
    end
  
  # s.resource_bundles = {
  #   'GMPhoneInfo' => ['GMPhoneInfo/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
