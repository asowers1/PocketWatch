# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
use_frameworks!

target 'PocketWatch' do
  
pod 'PocketAPI'
pod 'RealmSwift'
pod 'SwiftHTTP', '~> 1.0.0'
pod 'Taplytics'
pod 'Fabric'
pod 'Crashlytics'
pod 'FZBase', :path => 'library/FZBase'
pod 'FZCacheHandler', :path => 'library/FZCacheHandler'
pod 'FZCache', :path => 'library/FZCache'
#pod 'FZAlertView', :path => 'library/FZAlertView'
#pod 'FZActionSheet', :path => 'library/FZActionSheet'
#pod 'FZReusableXibView', :path => 'library/FZReusableXibView'
#pod 'FZDebugMenu', :path => 'library/FZDebugMenu'
#pod 'FZVariableSwitcher', :path => 'library/FZVariableSwitcher'
pod 'pop', '~> 1.0'
pod 'MBProgressHUD', '~> 0.9.1'
pod 'RESideMenu', '~> 4.0.7'
pod 'Koloda', '~> 2.0.6'
pod 'AFNetworking', '2.6.0'
end

target 'PocketWatchTests' do
pod 'PocketAPI'
pod 'RealmSwift'
pod 'SwiftHTTP', '~> 1.0.0'
pod 'Taplytics'
end

target 'PocketWatchUITests' do
pod 'PocketAPI'
pod 'RealmSwift'
pod 'SwiftHTTP', '~> 1.0.0'
pod 'Taplytics'
end

post_install do |installer|
  `find Pods -regex 'Pods/pop.*\\.h' -print0 | xargs -0 sed -i '' 's/\\(<\\)pop\\/\\(.*\\)\\(>\\)/\\"\\2\\"/'`
end

