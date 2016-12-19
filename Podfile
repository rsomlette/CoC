# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'

post_install do |installer_representation|
	installer_representation.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings['SWIFT_VERSION'] = '3.0'
			config.build_settings['CLANG_ENABLE_CODE_COVERAGE'] = 'NO'
		end
	end
end

target 'CoC' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for CoC
  pod 'RxSwift', '~> 3.0.0'
  pod 'RxCocoa', '~> 3.0.0'
  pod 'Moya/RxSwift', '~> 8.0.0-beta.3'
#  pod 'Moya-ModelMapper/RxSwift', '~> 4.0.0-beta.3'
  pod 'Moya-ObjectMapper', :git => 'https://github.com/ivanbruel/Moya-ObjectMapper'
#  pod 'RxOptional', '~> 3.1.0'
  pod 'RxRealm',  '~> 0.3.2'
  pod 'RealmSwift', '~> 2.1.1'
#  pod 'RxAlamofire', '~> 3.0.0'
#  pod 'ObjectMapper', '~> 2.0'
#	pod 'AlamofireObjectMapper', '~> 4.0'
end
