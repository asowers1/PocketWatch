Pod::Spec.new do |s|
  s.name         = "FZReusableXibView"
  s.version      = "0.0.1"
  s.summary      = "Summary A module for easy reusable xib view"
  s.description  = "Description: A module for easy reusable xib view"
  s.homepage     = "https://www.fuzzproductions.com"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Sheng Dong" => "sheng@fuzzproductions.com" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => "git@gitlab.fuzzhq.com:ios-modules/fzreusablexibview.git", :tag => "v#{s.version}" }
  s.requires_arc = true
  s.source_files = 'FZReusableXibView/**/*.{h,m}'
end