# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Est Rouge Test' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Est Rouge Test

    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'SnapKit'
    pod 'Cache'
    pod 'Imaginary'

    post_install do |installer|
      installer.pods_project.targets.each do |target|
        if target.name == 'RxSwift'
          target.build_configurations.each do |config|
            if config.name == 'Debug'
              config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
            end
          end
        end
      end
    end

end

target 'Est_Rouge_Test_Tests' do

  use_frameworks!

  pod 'RxSwift'
  pod 'RxCocoa'

end


