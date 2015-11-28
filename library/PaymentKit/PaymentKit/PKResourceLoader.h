//
//  PKResourceLoader.h
//  Pods
//
//  Created by Sheng Dong on 3/19/15.
//
//

@import UIKit;

/**
 *  Reason for creating this class to load resource is because of the change from cocoapod. If a project specify their pod to be a framework, loading image using imageName will fail because it load from main bundle. This loader will load from the appropriate bundle.
    Note that the pod spec is also changed to create the resource bundle
 */

@interface PKResourceLoader : NSObject

+ (UIImage *)imageWithName:(NSString *)name extension:(NSString *)extension;
+ (UIImage *)imageWithName:(NSString *)name;

@end
