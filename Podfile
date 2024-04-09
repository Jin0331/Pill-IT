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
  pod 'Parchment', '~> 3.3'
  pod 'MarqueeLabel'
  pod 'Tabman', '~> 3.0'
  pod 'RxSwift', '6.6.0'
  pod 'RxCocoa', '6.6.0'
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


#post_install do |installer|
#    sharedLibrary = installer.aggregate_targets.find { |aggregate_target| aggregate_target.name == 'Pods-[MY_FRAMEWORK_TARGET]' }
#    installer.aggregate_targets.each do |aggregate_target|
#        if aggregate_target.name == 'Pods-[MY_APP_TARGET]'
#            aggregate_target.xcconfigs.each do |config_name, config_file|
#                sharedLibraryPodTargets = sharedLibrary.pod_targets
#                aggregate_target.pod_targets.select { |pod_target| sharedLibraryPodTargets.include?(pod_target) }.each do |pod_target|
#                    pod_target.specs.each do |spec|
#                        frameworkPaths = unless spec.attributes_hash['ios'].nil? then spec.attributes_hash['ios']['vendored_frameworks'] else spec.attributes_hash['vendored_frameworks'] end || Set.new
#                        frameworkNames = Array(frameworkPaths).map(&:to_s).map do |filename|
#                            extension = File.extname filename
#                            File.basename filename, extension
#                        end
#                    end
#                    frameworkNames.each do |name|
#                        if name != '[DUPLICATED_FRAMEWORK_1]' && name != '[DUPLICATED_FRAMEWORK_2]'
#                            raise("Script is trying to remove unwanted flags: #{name}. Check it out!")
#                        end
#                        puts "Removing #{name} from OTHER_LDFLAGS"
#                        config_file.frameworks.delete(name)
#                    end
#                end
#            end
#            xcconfig_path = aggregate_target.xcconfig_path(config_name)
#            config_file.save_as(xcconfig_path)
#        end
#    end
#end
