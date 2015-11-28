Pod::Spec.new do |s|
  s.name         = "FZActionSheet"
  s.version      = "0.0.9"
  s.summary      = "This is the summary"
  s.description  = "This is the extra long description for more detail than the summary"
  s.homepage     = "http://www.fuzzproductions.com"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Sean Orelli" => "sean@fuzzproductions.com" }
  s.platform     = :ios, '6.0'
  s.source       = { :git => "git@gitlab.fuzzhq.com:ios-modules/actionsheet.git", :tag => '0.0.9' }
  s.source_files = '*.{h,m}'
  s.requires_arc = true
  s.dependency 'FZBase'
end
