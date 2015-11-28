Pod::Spec.new do |s|
  s.name     = 'FZCache'
  s.version  = '0.2.9'
  s.license  = 'MIT'
  s.summary  = 'A caching library that supports caching limits and types.'
  s.homepage = 'https://gitlab.fuzzhq.com/ios-modules/fzcache'
  s.authors  = { 'Anton Remizov' => 'anton@fuzzproductions.com' }
  s.source   = { :git => 'git@gitlab.fuzzhq.com:ios-modules/fzcache.git', :tag => "0.2.9", :submodules => true }
  s.requires_arc = true
  s.ios.deployment_target = '6.0'
  s.public_header_files = 'FZCache/*.h'
  s.source_files = 'FZCache/*'
  s.dependency 'AFNetworking'
  s.dependency 'FZBase'
end