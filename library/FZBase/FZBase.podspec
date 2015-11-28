Pod::Spec.new do |s|
  s.name         = "FZBase"
  s.version      = "0.4.19"
  s.summary      = "A module for common scripts and source extending UIKit"
  s.description  = "A module for commons script, functions, macros, tyopedefs, and UIKit categories that simplify the iOS sdk"
  s.homepage     = "http://www.fuzzproductions.com"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Sean Orelli" => "sean@fuzzproductions.com" }
  s.platform     = :ios, '6.0'
  s.source       = { :git => "git@gitlab.fuzzhq.com:ios-modules/base.git", :tag => '0.4.19' }
  s.requires_arc = true
  s.framework  = 'AVFoundation'
  s.framework  = 'Security'
  s.framework  = 'CoreGraphics'


  s.subspec 'Fuzz' do |sp|
    sp.source_files = 'Source/Fuzz.{h,m}'
    sp.requires_arc = true
  end
  s.subspec 'FZDemoBaseViewController' do |sp|
    sp.source_files = 'Source/FZDemoBaseViewController.{h,m}'
    sp.requires_arc = true
    sp.dependency 'FZBase/Fuzz'
    sp.dependency 'FZBase/NSObject+Fuzz'
    sp.dependency 'FZBase/UIView+Fuzz'
    sp.dependency 'FZBase/UIDevice+Fuzz'
  end

  s.subspec 'FZBaseDemoViewController' do |sp|
    sp.source_files = 'Source/FZBaseDemoViewController.{h,m}'
    sp.requires_arc = true
    sp.dependency 'FZBase/Fuzz'
    sp.dependency 'FZBase/NSObject+Fuzz'
    sp.dependency 'FZBase/UIView+Fuzz'
  end

  s.subspec 'NSArray+Fuzz' do |sp|
    sp.source_files = 'Source/NSArray+Fuzz.{h,m}'
    sp.requires_arc = true
    sp.dependency 'FZBase/Fuzz'
  end

  s.subspec 'NSBundle+Fuzz' do |sp|
    sp.source_files = 'Source/NSBundle+Fuzz.{h,m}'
    sp.requires_arc = true
    sp.dependency 'FZBase/Fuzz'
  end  

  s.subspec 'NSDate+Fuzz' do |sp|
   sp.source_files = 'Source/NSDate+Fuzz.{h,m}'
   sp.requires_arc = true
   sp.dependency 'FZBase/Fuzz'
   sp.dependency 'FZBase/NSObject+Fuzz'
   sp.dependency 'FZBase/UIDevice+Fuzz'
  end


  s.subspec 'NSData+Fuzz' do |sp|
   sp.source_files = 'Source/NSData+Fuzz.{h,m}'
   sp.requires_arc = true
   sp.dependency 'FZBase/Fuzz'
  end

  s.subspec 'NSDictionary+Fuzz' do |sp|
   sp.source_files = 'Source/NSDictionary+Fuzz.{h,m}'
   sp.requires_arc = true
   sp.dependency 'FZBase/Fuzz'
  end

  s.subspec 'NSError+Fuzz' do |sp|
    sp.source_files = 'Source/NSError+Fuzz.{h,m}'
    sp.requires_arc = true
    sp.dependency 'FZBase/Fuzz'
  end

  s.subspec 'NSFileManager+Fuzz' do |sp|
    sp.source_files = 'Source/NSFileManager+Fuzz.{h,m}'
    sp.requires_arc = true
    sp.dependency 'FZBase/Fuzz'
    sp.dependency 'FZBase/NSObject+Fuzz'
    sp.dependency 'FZBase/NSError+Fuzz'
  end  

  s.subspec 'NSObject+Fuzz' do |sp|
   sp.source_files = 'Source/NSObject+Fuzz.{h,m}'
   sp.requires_arc = false
   sp.dependency 'FZBase/Fuzz'
  end

  s.subspec 'NSString+Fuzz' do |sp|
    sp.source_files = 'Source/NSString+Fuzz.{h,m}'
    sp.requires_arc = true
    sp.dependency 'FZBase/Fuzz'
    sp.dependency 'FZBase/NSFileManager+Fuzz'
    sp.dependency 'FZBase/NSXMLParser+Fuzz'
  end  

  s.subspec 'NSURL+Fuzz' do |sp|
    sp.source_files = 'Source/NSURL+Fuzz.{h,m}'
    sp.requires_arc = true
    sp.dependency 'FZBase/Fuzz'
    sp.dependency 'FZBase/NSFileManager+Fuzz'
  end  


  s.subspec 'NSURLRequest+Fuzz' do |sp|
    sp.source_files = 'Source/NSURLRequest+Fuzz.{h,m}'
    sp.requires_arc = true
    sp.dependency 'FZBase/Fuzz'
    sp.dependency 'FZBase/NSFileManager+Fuzz'
  end  


  s.subspec 'NSURLSession+Fuzz' do |sp|
    sp.source_files = 'Source/NSURLSession+Fuzz.{h,m}'
    sp.requires_arc = true
    sp.dependency 'FZBase/Fuzz'
    sp.dependency 'FZBase/NSFileManager+Fuzz'
  end  

  s.subspec 'NSXMLParser+Fuzz' do |sp|
    sp.source_files = 'Source/NSXMLParser+Fuzz.{h,m}'
    sp.requires_arc = true
    sp.dependency 'FZBase/Fuzz'
  end

  s.subspec 'UIButton+Fuzz' do |sp|
    sp.source_files = 'Source/UIButton+Fuzz.{h,m}'
    sp.requires_arc = true
    sp.dependency 'FZBase/Fuzz'
    sp.dependency 'FZBase/UIImage+Fuzz'
  end  

  s.subspec 'UIColor+Fuzz' do |sp|
    sp.source_files = 'Source/UIColor+Fuzz.{h,m}'
    sp.requires_arc = true
    sp.dependency 'FZBase/Fuzz'
  end  

  s.subspec 'UIDevice+Fuzz' do |sp|
    sp.source_files = 'Source/UIDevice+Fuzz.{h,m}'
    sp.requires_arc = true
    sp.dependency 'FZBase/Fuzz'
    sp.dependency 'FZBase/CMMotionManager+Fuzz'
  end  


  s.subspec 'UIFont+Fuzz' do |sp|
    sp.source_files = 'Source/UIFont+Fuzz.{h,m}'
    sp.requires_arc = true
    sp.dependency 'FZBase/Fuzz'
    sp.dependency 'FZBase/NSObject+Fuzz'
  end  

  s.subspec 'UIImage+Fuzz' do |sp|
    sp.source_files = 'Source/UIImage+Fuzz.{h,m}'
    sp.requires_arc = true
    sp.dependency 'FZBase/Fuzz'
    sp.dependency 'FZBase/NSObject+Fuzz'
    sp.dependency 'FZBase/UIView+Fuzz'
  end    
  
  s.subspec 'UILabel+Fuzz' do |sp|
    sp.source_files = 'Source/UILabel+Fuzz.{h,m}'
    sp.requires_arc = true
    sp.dependency 'FZBase/Fuzz'
    sp.dependency 'FZBase/UIView+Fuzz'
    sp.dependency 'FZBase/NSObject+Fuzz'
  end  

   s.subspec 'UIView+Fuzz' do |sp|
    sp.source_files = 'Source/UIView+Fuzz.{h,m}'
    sp.requires_arc = true
    sp.dependency 'FZBase/Fuzz'
    sp.dependency 'FZBase/NSObject+Fuzz'
  end

  s.subspec 'UITextView+Fuzz' do |sp|
    sp.source_files = 'Source/UITextView+Fuzz.{h,m}'
    sp.requires_arc = true
    sp.dependency 'FZBase/Fuzz'
    sp.dependency 'FZBase/UIView+Fuzz'
  end

  s.subspec 'UITableView+Fuzz' do |sp|
    sp.source_files = 'Source/UITableView+Fuzz.{h,m}'
    sp.requires_arc = true
    sp.dependency 'FZBase/Fuzz'
    sp.dependency 'FZBase/UIView+Fuzz'
  end
  s.subspec 'UICollectionView+Fuzz' do |sp|
    sp.source_files = 'Source/UICollectionView+Fuzz.{h,m}'
    sp.requires_arc = true
    sp.dependency 'FZBase/Fuzz'
    sp.dependency 'FZBase/UIView+Fuzz'
  end

  s.subspec 'UIImageView+Fuzz' do |sp|
    sp.source_files = 'Source/UIImageView+Fuzz.{h,m}'
    sp.requires_arc = true
    sp.dependency 'FZBase/Fuzz'
    sp.dependency 'FZBase/UIView+Fuzz'
    sp.dependency 'FZBase/NSString+Fuzz'
    sp.dependency 'FZBase/NSURLSession+Fuzz'
    sp.dependency 'FZBase/NSFileManager+Fuzz'
  end


  s.subspec 'CMMotionManager+Fuzz' do |sp|
    sp.source_files = 'Source/CMMotionManager+Fuzz.{h,m}'
    sp.requires_arc = true
    sp.dependency 'FZBase/Fuzz'
    sp.dependency 'FZBase/UIImage+Fuzz'
  end  
end
