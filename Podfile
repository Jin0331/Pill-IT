# Uncomment the next line to define a global platform for your project
 platform :ios, '15.0'

target 'Pill-IT' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Pill-IT
  pod 'Alamofire', '~> 5.8'
  pod 'RealmSwift', '~> 10.45.0'
  pod 'SwipeableTabBarController'
  pod 'SnapKit', '~> 5.7.0'
  pod 'Then'
  pod 'SearchTextField'
  pod 'Kingfisher', '~> 7.0'
  pod 'Toast-Swift', '~> 5.1.0'
  pod 'NVActivityIndicatorView'
  pod 'YPImagePicker'
  pod 'SwipeCellKit'
  pod 'FSCalendar'
  pod 'Parchment', '~> 3.3'
end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      end
    end
  end
end
