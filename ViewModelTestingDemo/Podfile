source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target 'ViewModelTestingDemo' do
    pod 'AlamofireImage', '~> 3.1'
    pod 'Intrepid', '~> 0.6.1'
end

target 'ViewModelTestingDemoTests' do
    pod 'AlamofireImage', '~> 3.1'
    pod 'OHHTTPStubs'
    pod 'OHHTTPStubs/Swift'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
  end
