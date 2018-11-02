platform :ios, '9.0'
inhibit_all_warnings!
use_frameworks!

target 'CacheManager' do
    pod 'RealmSwift'
end

target 'CacheManagerTests' do
    pod 'Quick'
    pod 'Nimble'
    pod 'RealmSwift'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.2'
        end
    end
end
