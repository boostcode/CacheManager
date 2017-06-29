Pod::Spec.new do |s|
   s.platform = :ios
   s.ios.deployment_target = '9.0'
   s.name = "CacheManager"
   s.summary = "CacheManager lets you cache objects locally using Realm, and then manage them."
   s.requires_arc = true
   s.version = "0.1.1"
   s.license = { :type => "MIT", :file => "LICENSE" }
   s.author = { "Matteo Crippa" => "matteo@boostco.de" }
   s.homepage = "http://boostco.de"
   s.source = { :git => "https://github.com/boostcode/CacheManager.git", :tag => "0.1.1"}
   s.framework = 'Foundation'
   s.dependency 'RealmSwift'
   s.source_files = "CacheManager/*.{swift}"
end
