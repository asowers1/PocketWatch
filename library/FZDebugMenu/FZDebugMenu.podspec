Pod::Spec.new do |s|
  s.name         = "FZDebugMenu"
  s.version      = "0.0.1"
  s.summary      = "A menu for debugging purpose."
  s.description  = "Description: A menu for debugging purpose"
  s.homepage     = "https://www.fuzzproductions.com"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Sheng Dong" => "sheng@fuzzproductions.com" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => "git@gitlab.fuzzhq.com:ios-modules/fzdebugmenu.git", :tag => "v#{s.version}" }
  s.requires_arc = true
  s.source_files = 'FZDebugMenu/**/*.{h,m}'
  s.dependency 'FZBase'
end