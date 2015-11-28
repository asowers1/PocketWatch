//
//  PKResourceLoader.m
//  Pods
//
//  Created by Sheng Dong on 3/19/15.
//
//

#import "PKResourceLoader.h"

@implementation PKResourceLoader

+ (UIImage *)imageWithName:(NSString *)name {
    return [self imageWithName:name extension:@"png"];
}
+ (UIImage *)imageWithName:(NSString *)name extension:(NSString *)extension {
    UIImage *imageFromMainBundle = [UIImage imageNamed:name];
    if (imageFromMainBundle) {
        return imageFromMainBundle;
    }
    UIImage *imageFromPKResourceBundle;
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)) {
        imageFromPKResourceBundle = [UIImage imageNamed:name inBundle:[self paymentKitResourcesBundle] compatibleWithTraitCollection:nil];
    } else {
        NSString *bundlePath = [[self paymentKitResourcesBundle] resourcePath];
        NSString *imagePath = [bundlePath stringByAppendingPathComponent:[self imageNameWithSystemScale:name andExtension:extension]];
        CGFloat scale = [[UIScreen mainScreen] scale];
        NSData *data = [NSData dataWithContentsOfFile:imagePath];
        imageFromPKResourceBundle = [UIImage imageWithData:data scale:scale];
    }
    
    return imageFromPKResourceBundle;
}

+ (NSString *)imageNameWithSystemScale:(UIImage *)imageName andExtension:(NSString *)extension {
    
    NSInteger scale = [[UIScreen mainScreen] scale];
    NSString *scalePrefix = [NSString stringWithFormat:@"@%dx", scale];
    NSString *imageNameWithScale = [NSString stringWithFormat:@"%@%@.%@",imageName, scalePrefix, extension];
    return imageNameWithScale;
    
}

+ (NSBundle*)paymentKitResourcesBundle {
    static dispatch_once_t onceToken;
    static NSBundle *pkResourcesBundle = nil;
    dispatch_once(&onceToken, ^{
        pkResourcesBundle = [NSBundle bundleWithURL:[[NSBundle bundleForClass:[self class]] URLForResource:@"PaymentKitResources" withExtension:@"bundle"]];
    });
    return pkResourcesBundle;
}
@end
