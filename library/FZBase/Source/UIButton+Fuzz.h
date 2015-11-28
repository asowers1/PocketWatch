//
//  UIButton+Fuzz.h
//  
//
//  Created by Fuzz Productions on 11/6/13.
//
//


//ARC_YES

#import "Fuzz.h"



/*
	This category should add the ability to remove the block
	Should check the ARC /retain properties of the block being 
	added, it is currently a retained associeated object after 
	the block is copied
 */

@interface UIButton (Fuzz)

/**
 * @description This method is exactly analgous to addTarget:action:forControlEvents.
 * @param inBlock A block to be invoked on button UIControlEventTouchUpInside.
 */
-(void)addButtonPressBlock:(FZBlock)inBlock;

/**
 * @description This method is similar to addTarget:action:forControlEvents, though it guarantees that the button will never have more than one target.
 * @param inBlock A block to be invoked on button UIControlEventTouchUpInside.
 */
-(void)setButtonPressBlock:(FZBlock)inBlock;

-(void)setColor:(UIColor *)inColor forState:(UIControlState)state;

//+(instancetype)buttonForDownloadingURLString:(NSString*)inUrlString withProgress:(FZBlock)inProgress andCompletion:(FZBlock)inBlock;

@end
