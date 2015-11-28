Pod::Spec.new do |s|
  s.name         = "FZCacheHandler"
  s.version      = "0.0.1"
  s.summary      = "This is the summary"
  s.description  = "This is the extra long description for more detail than the summary"
  s.homepage     = "https://www.fuzzproductions.com"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Sean Orelli" => "sean@fuzzproductions.com" }
  s.platform     = :ios, '5.0'
  s.source       = { :git => "git@git.fuzzhq.com:fuzz-modulelibrary-cachehandler.git", :tag => '0.0.1' }
  s.source_files = '*.{h,m}'
  s.requires_arc = false
  s.dependency   'FZBase'
end
