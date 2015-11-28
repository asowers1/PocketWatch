Pod::Spec.new do |s|
  s.name         = "FZFacebookHandler"
  s.version      = "0.1.3"
  s.summary      = "A wrapper around common Facebook calls"
  s.description  = "Use this wrapper to maintain a common, API-agnostic interface for Facebook calls."
  s.homepage     = "http://www.fuzzproductions.com"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Christopher Luu" => "chrisluu@fuzzproductions.com" }
  s.platform     = :ios, '6.0'
  s.source       = { :git => "git@gitlab.fuzzhq.com:ios-modules/facebookhandler.git", :tag => '0.1.3' }
  s.source_files = '*.{h,m}'
  s.requires_arc = true
  s.dependency 'FZBase'
  s.dependency 'FZCacheHandler'
  s.dependency 'FZAlertView'
  s.dependency 'Facebook-iOS-SDK'
end
