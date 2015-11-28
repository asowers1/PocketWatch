//
//  FZReusableXibView.h
//  FZReusableXibView
//
//  Created by Sheng Dong on 12/12/14.
//  Copyright (c) 2014 Fuzz Productions. All rights reserved.
//

#import <UIKit/UIKit.h>


/** 
 
 Background:
 Reusing view that is layed out in a Xib is somewhat unsupported natively. This class serves as the bridge that will achieve that goal by wrapping the xib view with a container view. The cons of this approach is that there is one extra view on the hierachy, and you have to follow certain rules when creating those reusable views. However, you get to reuse the xib view.
 
 Step:
 1. Create your custom class and have it subclass ReusableXibView
 2. Create the corresponding Xib View. (The xib file can have different name, just make sure you override xibName in your subclass)
 3. Make sure the view of interest in the xib is the top level view (first view).
 4. Make sure the xib is in your main bundle (if you don't do anything, it's automatically in the main bundle)
 5. Declare the file owner of the xib file to be your custom class. This will enable you to drag IBOutlets.

 */

IB_DESIGNABLE
@interface FZReusableXibView : UIView

// Override this if the xib have different name as the class
- (NSString *)xibName;

@end
