//
//  UIDevice+Fuzz.m
//  
//
//  Created by Fuzz Productions on 11/6/13.
//
//

#import "UIDevice+Fuzz.h"
#import "Fuzz.h"
#import "NSError+Fuzz.h"
#import "CMMotionManager+Fuzz.h"
#import <AVFoundation/AVFoundation.h>
#import <MessageUI/MessageUI.h>
#import <CoreMotion/CoreMotion.h>
#import <AudioToolbox/AudioServices.h>
#import <sys/sysctl.h>
//@import AudioToolbox;



@implementation UIDevice (Fuzz)

+ (NSString*)uuid{return [[[UIDevice currentDevice] identifierForVendor] UUIDString];}

+ (BOOL)isSimulated
{
	NSString *model = [[UIDevice currentDevice] model];
	if ([model isEqualToString:@"iPhone Simulator"]) return YES;
	if ([model isEqualToString:@"iPad Simulator"]) return YES;
	return NO;
}

+ (BOOL)isIPad{return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);}
+ (BOOL)isIPhone{return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);}
+ (NSString*)model{return [[UIDevice currentDevice] model];}
+ (NSString*)system{return [[UIDevice currentDevice] systemName];}
+ (CGFloat)systemVersion{return [[[UIDevice currentDevice] systemVersion] floatValue];}

+(NSString*)batteryState
{
    switch ([[UIDevice currentDevice] batteryState])
    {
        case UIDeviceBatteryStateUnplugged:	return @"Unplugged";	break;
        case UIDeviceBatteryStateCharging:	return @"Charging";		break;
        case UIDeviceBatteryStateFull:		return @"Full";			break;
        case UIDeviceBatteryStateUnknown:	return @"Unknown";
    }
    return @"Unknown";
}

+ (void)logSystemValues
{
    DLog(@" ");
    DLog(@"UDID:        %@", [UIDevice uuid]);
    DLog(@"Model:       %@", [UIDevice model]);
    DLog(@"System:      %@", [UIDevice system]);
    DLog(@"Version:     %f", [UIDevice systemVersion]);
	DLog(@"%@",([UIDevice hasRetinaScreen ])	? @"retina       YES"	: @"retina       NO" );
	DLog(@"%@",([UIDevice isIPad])				? @"is iPad      YES"	: @"is iPad      NO");
	DLog(@"%@",([UIDevice isIPhone])			? @"is iPhone    YES"	: @"is iPhone    NO");
	DLog(@"%@",([UIDevice hasTelephone])		? @"Telephone    YES"	: @"Telephone    NO");
	DLog(@"%@",([UIDevice hasMicrophone])		? @"Microphone   YES"	: @"Microhone    NO");
	DLog(@"%@",([UIDevice hasCamera])			? @"Camera       YES"	: @"Camera       NO");
	DLog(@"%@",([UIDevice hasPhotoLibrary])		? @"Photos       YES"	: @"Photos       NO");
	DLog(@"%@",([UIDevice has4InchScreen])		? @"4 inch screen "		: @"3.5 inch screen ratio");
    DLog(@"Battery State %@", [UIDevice batteryState]);
    
}



- (NSUInteger) getSysInfo: (uint) typeSpecifier
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

- (NSUInteger) totalMemory{return [self getSysInfo:HW_PHYSMEM];}
- (NSUInteger) userMemory{return [self getSysInfo:HW_USERMEM];}

- (NSNumber *) totalDiskSpace
{
	NSError *error = nil;
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
	ELog(error);
    return [fattributes objectForKey:NSFileSystemSize];
}

- (NSNumber *) freeDiskSpace
{
	NSError *error = nil;
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
	ELog(error);
    return [fattributes objectForKey:NSFileSystemFreeSize];
}

/*
 These arent working, why not?
+ (void)vibrate
{
    DLog(@" vibrate");
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
}

+ (void)vibrateOrBeep
{
    DLog(@" vibrate or beep");
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}
*/


+ (BOOL)isPortraitOrientation{return UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation);}
+ (BOOL)isLandscapeOrientation{return UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation);}
+ (BOOL)hasPortraitInterface{return UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);}
+ (BOOL)hasLandscapeInterface{return UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);}
+ (BOOL)hasRetinaScreen{return ([[UIScreen mainScreen] scale] >= 2.0) ? YES:NO;}
+ (BOOL)hasPhotoLibrary{return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];}
+ (BOOL)hasTelephone{return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]];}
+ (BOOL)hasSMS{return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sms://"]];}
+ (BOOL)hasMicrophone{return [[AVAudioSession sharedInstance] isInputAvailable];}
+ (BOOL)hasCamera{return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];}
+ (BOOL)hasEmail{return [MFMailComposeViewController canSendMail];}
+ (BOOL)hasGyroscope{return [CMMotionManager shared].gyroAvailable;}
+ (BOOL)has4InchScreen __deprecated
{
	if([UIDevice isIPhone])
		if([[UIScreen mainScreen] bounds].size.height > 480)
			return YES;
	
	return NO;
}


@end
