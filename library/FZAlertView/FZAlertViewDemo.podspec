Pod::Spec.new do |s|
  s.name         = "FZAlertViewDemo"
  s.version      = "0.0.14"
  s.summary      = "This is the summary"
  s.description  = "This is the extra long description for more detail than the summary"
  s.homepage     = "https://www.fuzzproductions.com"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Sean Orelli" => "sean@fuzzproductions.com" }
  s.platform     = :ios, '5.0'
  s.source       = { :git => "git@gitlab.fuzzhq.com:ios-modules/alertview.git", :tag => '0.0.14' }
  s.source_files = 'DemoViewController/*'
  s.requires_arc = true

  s.dependency 'FZAlertView'
  s.dependency 'FZBase', '~> 0.1.0'
  
end
