use_frameworks!
platform :ios, '9.0'

pod 'Bolts'
pod 'Parse'
pod 'ParseUI'
pod 'ParseCrashReporting'
pod 'ParseFacebookUtilsV4'


post_install do |installer|
    installer.pods_project.build_configuration_list.build_configurations.each do |configuration|
        configuration.build_settings['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = 'YES'
    end
end