//
//  FZReusableXibView.m
//  FZReusableXibView
//
//  Created by Sheng Dong on 12/12/14.
//  Copyright (c) 2014 Fuzz Productions. All rights reserved.
//

#import "FZReusableXibView.h"

@interface FZReusableXibView()
@property (nonatomic, strong) UIView *containerView;
@end

@implementation FZReusableXibView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadFromXib];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadFromXib];
    }
    return self;
}

- (NSString *)xibName
{
    return @"";
}

- (void)loadFromXib
{
    NSBundle *mainBundle = [NSBundle bundleForClass:[self class]];
    NSString *xibName = [self xibName];
    if (xibName && ![xibName isEqualToString:@""]) {
        // There is an override, use that xibName instead
    } else {
        // There isn't an override, use the current class name.
        xibName = NSStringFromClass([self class]);
    }
    NSArray *loadedViews = [mainBundle loadNibNamed:xibName owner:self options:nil];
    if (!loadedViews) {
        // If no xib is found, just return
        return;
    }
    UIView *loadedSubview = [loadedViews firstObject];
    // This check and set the frame is neccessary, if not there will be console error about unsatisfy constraints
    if (CGRectEqualToRect(self.frame, CGRectZero)) {
        self.frame = loadedSubview.frame;
    }
    
    [super addSubview:loadedSubview];
    loadedSubview.translatesAutoresizingMaskIntoConstraints = NO;
    self.containerView = loadedSubview;
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeTop]];
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeLeft]];
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeBottom]];
    [self addConstraint:[self pin:loadedSubview attribute:NSLayoutAttributeRight]];
}

- (NSLayoutConstraint *)pin:(id)item attribute:(NSLayoutAttribute)attribute
{
    return [NSLayoutConstraint constraintWithItem:self
                                        attribute:attribute
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:item
                                        attribute:attribute
                                       multiplier:1.0
                                         constant:0.0];
}

- (void)addSubview:(UIView *)view {
    [self.containerView addSubview:view];
}

- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index {
    [self.containerView insertSubview:view atIndex:index];
}

- (void)insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview {
    [self.containerView insertSubview:view aboveSubview:siblingSubview];
}

- (void)insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview {
    [self.containerView insertSubview:view belowSubview:siblingSubview];
}

- (void)bringSubviewToFront:(UIView *)view {
    [self.containerView bringSubviewToFront:view];
}

- (void)sendSubviewToBack:(UIView *)view {
    [self.containerView sendSubviewToBack:view];
}

@end