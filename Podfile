use_frameworks!
platform :ios, '9.0'

target ‘WatervilleFood’ do
	pod 'Bolts'
	pod 'Parse'
	pod 'ParseUI'
	pod 'ParseCrashReporting'
	pod 'ParseFacebookUtilsV4'
    pod 'Stripe'
	pod 'SwiftSpinner'
	pod 'AIFlatSwitch', '~> 0.0.1'
	pod 'UIColor_Hex_Swift'
    pod 'ZFRippleButton'
end

post_install do |installer|
    installer.pods_project.build_configuration_list.build_configurations.each do |configuration|
        configuration.build_settings['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = 'YES'
    end
end
