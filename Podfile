source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target 'Aquatic Saver' do
    pod 'Alamofire', '~> 4.7'
    pod 'GoogleMaps'
    pod 'PromiseKit', '~> 6.0'
    pod 'Material', '~> 2.0'
    pod 'IQKeyboardManager'
    pod 'Starscream', '~> 3.0.2'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.1.2'
        end
    end
end
