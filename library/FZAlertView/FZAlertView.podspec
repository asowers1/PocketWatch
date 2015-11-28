Pod::Spec.new do |s|
  s.name         = "FZAlertView"
  s.version      = "0.1.5"
  s.summary      = "A simplified constructor that provides a range of UIAlertView functionality"
  s.description  = "While this project is still a work in progress, the end goal is to consolidate standard UIAlertView/UIAlertController behavior in a single module."
  s.homepage     = "https://www.fuzzproductions.com"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Sean Orelli" => "sean@fuzzproductions.com" }
  s.platform     = :ios, '5.0'
  s.source       = { :git => "git@gitlab.fuzzhq.com:ios-modules/alertview.git", :tag => '0.1.5' }
  s.source_files = '*.{h,m}'
  s.requires_arc = true
end
