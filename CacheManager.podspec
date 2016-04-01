Pod::Spec.new do |s|

   s.platform = :ios
   s.ios.deployment_target = '9.0'
   s.name = "CacheManager"
   s.summary = "CacheManager lets you manage objects with realm caching."
   s.requires_arc = true

   s.version = "0.0.1"
   s.license = { :type => "MIT", :file => "LICENSE" }
   s.author = { "Matteo Crippa" => "matteo@boostco.de" }
   s.homepage = "http://boostco.de"
   s.source = { :git => "https://gitlab.com/matteocrippa/cachemanager-lib-ios.git", :tag => "0.0.1"}
   s.framework = 'Foundation'
   s.dependency 'RealmSwift'
   #s.dependency 'Quick'
   #s.dependency 'Nimble'
   s.source_files = "CacheManager/*.{swift}"
end
