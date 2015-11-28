Pod::Spec.new do |s|
  s.name         = "FZVariableSwitcher"
  s.version      = "0.0.4"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.summary      = "Fuzz Variable Switcher"
  s.description  = "Read README.md"
  s.homepage     = "http://www.fuzzproductions.com"
  s.author       = { "Sheng Dong" => "sheng@fuzzproductions.com" }
  s.platform     = :ios, '6.0'
  s.source       = { :git => "git@gitlab.fuzzhq.com:ios-modules/fzvariableswitcher.git", :tag => '0.0.4' }
  s.frameworks = 'SystemConfiguration', 'MobileCoreServices'
  s.source_files = "FZVariableSwitcher/**/*.{h,m}"
  s.resources = 'FZVariableSwitcher/**/*.{xib,plist,storyboard}'
  s.requires_arc = true
  s.dependency 'FZBase'
  s.dependency 'FZAlertView'
end