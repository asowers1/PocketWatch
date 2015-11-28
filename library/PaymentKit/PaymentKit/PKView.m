//
//  PKPaymentField.m
//  PKPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#define kPKRedColor [UIColor colorWithRed:253.0/255.0 green:0.0 blue:17.0/255.0 alpha:1.0]

#import <QuartzCore/QuartzCore.h>
#import "PKView.h"
#import "PKTextField.h"
#import "PKResourceLoader.h"

@interface PKView () <UITextFieldDelegate> {
	
@private
    BOOL isInitialState;
    BOOL isValidState;
}

- (void)setup;
- (void)setupPlaceholderView;
- (void)setupCardNumberField;
- (void)setupCardExpiryField;
- (void)setupCardCVCField;

- (void)stateCardNumber;
- (void)stateMeta;
- (void)stateCardCVC;

- (void)setPlaceholderViewImage:(UIImage *)image;
- (void)setPlaceholderToCVC;
- (void)setPlaceholderToCardType;

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString;
- (BOOL)cardNumberFieldShouldChangeCharactersInRange: (NSRange)range replacementString:(NSString *)replacementString;
- (BOOL)cardExpiryShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString;
- (BOOL)cardCVCShouldChangeCharactersInRange: (NSRange)range replacementString:(NSString *)replacementString;

- (void)checkValid;
- (void)textFieldIsValid:(UITextField *)textField;
- (void)textFieldIsInvalid:(UITextField *)textField withErrors:(BOOL)errors;
@end

@implementation PKView

@dynamic card;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setBorderStyle:(UITextBorderStyle)borderStyle
{
	_borderStyle = borderStyle;
	
	if (borderStyle == UITextBorderStyleRoundedRect) {
		self.layer.borderColor = [UIColor colorWithRed:191/255.0 green:192/255.0 blue:194/255.0 alpha:1.0].CGColor;
		self.layer.cornerRadius = 6.0;
		self.layer.borderWidth = 0.5;
	}
	else {
		self.layer.borderColor = nil;
		self.layer.cornerRadius = 0.0;
		self.layer.borderWidth = 0.0;
	}
}

- (void)setDefaultTextAttributes:(NSDictionary *)defaultTextAttributes
{
	_defaultTextAttributes = [defaultTextAttributes copy];
	
	// We shouldn't need to set the font and textColor attributes, but a bug exists in 7.0 (fixed in 7.1/)
	
	NSArray *textFields = @[_cardNumberField, _cardExpiryField, _cardCVCField, _cardLastFourField];
    for (PKTextField *textField in textFields) {
		textField.defaultTextAttributes = _defaultTextAttributes;
		textField.font = _defaultTextAttributes[NSFontAttributeName];
		textField.textColor = _defaultTextAttributes[NSForegroundColorAttributeName];
		textField.textAlignment = NSTextAlignmentLeft;
    }
	
	_cardExpiryField.textAlignment = NSTextAlignmentCenter;
	_cardCVCField.textAlignment = NSTextAlignmentCenter;
	
	[self setNeedsLayout];
}

- (void)setFont:(UIFont *)font
{
	NSMutableDictionary *defaultTextAttributes = [self.defaultTextAttributes mutableCopy];
	defaultTextAttributes[NSFontAttributeName] = font;
	
	self.defaultTextAttributes = [defaultTextAttributes copy];
}

- (UIFont *)font
{
	return self.defaultTextAttributes[NSFontAttributeName];
}

- (void)setTextColor:(UIColor *)textColor
{
	NSMutableDictionary *defaultTextAttributes = [self.defaultTextAttributes mutableCopy];
	defaultTextAttributes[NSForegroundColorAttributeName] = textColor;
	
	self.defaultTextAttributes = [defaultTextAttributes copy];
}

- (UIColor *)textColor
{
	return self.defaultTextAttributes[NSForegroundColorAttributeName];
}

- (void)setup
{
	self.imageStyle = PKViewImageStyleNormal;
	self.borderStyle = UITextBorderStyleRoundedRect;
	self.layer.masksToBounds = YES;
	self.backgroundColor = [UIColor whiteColor];
	
    isInitialState = YES;
    isValidState   = NO;
    
    [self setupPlaceholderView];
	
	self.innerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.frame.size.height)];
    self.innerView.clipsToBounds = YES;
	
	_cardLastFourField = [UITextField new];
	_cardLastFourField.defaultTextAttributes = _defaultTextAttributes;
	_cardLastFourField.backgroundColor = self.backgroundColor;
	
    [self setupCardNumberField];
    [self setupCardExpiryField];
    [self setupCardCVCField];
	
	self.defaultTextAttributes = @{
								   NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0],
								   NSForegroundColorAttributeName: [UIColor blackColor]};
	
    [self.innerView addSubview:_cardNumberField];
	
    [self addSubview:self.innerView];
    [self addSubview:_placeholderView];
    
	if (self.imageStyle == PKViewImageStyleNormal) {
		UIView *line = [[UIView alloc] initWithFrame:CGRectMake(_placeholderView.frame.size.width - 0.5, 0, 0.5,  _innerView.frame.size.height)];
		line.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.3];
		[self addSubview:line];
	}
	
    [self stateCardNumber];
}

- (PKTextField *)textFieldWithPlaceholder:(NSString *)placeholder
{
	PKTextField *textField = [PKTextField new];
	
	textField.delegate = self;
    textField.placeholder = placeholder;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.defaultTextAttributes = _defaultTextAttributes;
	textField.layer.masksToBounds = NO;
	
	return textField;
}

- (void)setupPlaceholderView
{
    UIImage *image = [PKResourceLoader imageWithName:@"placeholder"];
    _placeholderView = [[UIImageView alloc] initWithImage:image];
	_placeholderView.backgroundColor = [UIColor whiteColor];
}

- (void)setupCardNumberField
{
	_cardNumberField = [self textFieldWithPlaceholder:@"1234 5678 9012 3456"];
}

- (void)setupCardExpiryField
{
	UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, -6.0, 0.5, _innerView.frame.size.height)];
	line.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.3];
	
	_cardExpiryField = [self textFieldWithPlaceholder:@"MM/YY"];
	_cardExpiryField.leftView = line;
	_cardExpiryField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)setupCardCVCField
{
	UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, -6.0, 0.5, _innerView.frame.size.height)];
	line.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.3];
	
	_cardCVCField = [self textFieldWithPlaceholder:@"CVC"];
	_cardCVCField.leftView = line;
	_cardCVCField.leftViewMode = UITextFieldViewModeAlways;
}

// Accessors

- (PKCardNumber *)cardNumber
{
    return [PKCardNumber cardNumberWithString:_cardNumberField.text];
}

- (PKCardExpiry *)cardExpiry
{
    return [PKCardExpiry cardExpiryWithString:_cardExpiryField.text];
}

- (PKCardCVC *)cardCVC
{
    return [PKCardCVC cardCVCWithString:_cardCVCField.text];
}

- (void)layoutSubviews
{
	if (self.imageStyle == PKViewImageStyleOutline) {
		CGFloat height = 18;
		CGFloat y = (self.frame.size.height - height) / 2;
		CGFloat width = 25 + y;
		
		_placeholderView.frame = CGRectMake(0, y, width, height);
		_placeholderView.contentMode = UIViewContentModeRight;
	}
	else {
		_placeholderView.frame = CGRectMake(0, (self.frame.size.height - 32) / 2, 51, 32);
	}
	
	NSDictionary *attributes = self.defaultTextAttributes;
	
	CGSize lastGroupSize, cvcSize, cardNumberSize;
	
	if (self.cardNumber.cardType == PKCardTypeAmex) {
		cardNumberSize = [@"1234 567890 12345" sizeWithAttributes:attributes];
		lastGroupSize = [@"00000" sizeWithAttributes:attributes];
		cvcSize = [@"0000" sizeWithAttributes:attributes];
	}
	else {
		if (self.cardNumber.cardType == PKCardTypeDinersClub) {
			cardNumberSize = [@"1234 567890 1234" sizeWithAttributes:attributes];
		}
		else {
			cardNumberSize = [_cardNumberField.placeholder sizeWithAttributes:attributes];
		}
		
		lastGroupSize = [@"0000" sizeWithAttributes:attributes];
		cvcSize = [_cardCVCField.placeholder sizeWithAttributes:attributes];
	}
	
	CGSize expirySize = [_cardExpiryField.placeholder sizeWithAttributes:attributes];
	
	CGFloat textFieldY = (self.frame.size.height - lastGroupSize.height) / 2.0;
	
	CGFloat totalWidth = lastGroupSize.width + expirySize.width + cvcSize.width;
	
	CGFloat innerWidth = self.frame.size.width - _placeholderView.frame.size.width;
	CGFloat multiplier = (100.0 / totalWidth);
	
	CGFloat newLastGroupWidth = (innerWidth * multiplier * lastGroupSize.width) / 100.0;
	CGFloat newExpiryWidth    = (innerWidth * multiplier * expirySize.width)    / 100.0;
	CGFloat newCVCWidth       = (innerWidth * multiplier * cvcSize.width)       / 100.0;
	
	CGFloat lastGroupSidePadding = (newLastGroupWidth - lastGroupSize.width) / 2.0;
	
	  _cardNumberField.frame = CGRectMake((innerWidth / 2.0) - (cardNumberSize.width / 2.0),
										  textFieldY,
										  cardNumberSize.width,
										  cardNumberSize.height);
	
	_cardLastFourField.frame = CGRectMake(CGRectGetMaxX(_cardNumberField.frame) - lastGroupSize.width,
										  textFieldY,
										  lastGroupSize.width,
										  lastGroupSize.height);
	
	  _cardExpiryField.frame = CGRectMake(CGRectGetMaxX(_cardNumberField.frame) + lastGroupSidePadding,
										  textFieldY,
										  newExpiryWidth,
										  expirySize.height);

	     _cardCVCField.frame = CGRectMake(CGRectGetMaxX(_cardExpiryField.frame),
										  textFieldY,
										  newCVCWidth,
										  cvcSize.height);
	
	CGFloat x;
	
	if (isInitialState) {
		x = _placeholderView.frame.size.width;
	}
	else {
		x = _innerView.frame.origin.x;
	}
	
	        _innerView.frame = CGRectMake(x,
										  0.0,
										  CGRectGetMaxX(_cardCVCField.frame),
										  self.frame.size.height);
}

// State

- (void)stateCardNumber
{
	if ([self.delegate respondsToSelector:@selector(paymentView:didChangeState:)]) {
		[self.delegate paymentView:self didChangeState:PKViewStateCardNumber];
	}
	
    if (!isInitialState) {
        // Animate left
        isInitialState = YES;
		
		[UIView animateWithDuration:0.200 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			_cardExpiryField.leftView.alpha = 0.0;
		} completion:nil];
		
        [UIView animateWithDuration:0.400
                              delay:0
                            options:(UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction)
                         animations:^{
							 _innerView.frame = CGRectMake(_placeholderView.frame.size.width,
														   0,
														   _innerView.frame.size.width,
														   _innerView.frame.size.height);
							 
							 _cardNumberField.alpha = 1.0;
                         }
                         completion:^(BOOL completed) {
                             [_cardExpiryField removeFromSuperview];
                             [_cardCVCField removeFromSuperview];
							 [_cardLastFourField removeFromSuperview];
                         }];
    }
    
	if (self.isFirstResponder) {
    	[self.cardNumberField becomeFirstResponder];
	}
}

- (void)stateMeta
{
	if ([self.delegate respondsToSelector:@selector(paymentView:didChangeState:)]) {
		[self.delegate paymentView:self didChangeState:PKViewStateExpiry];
	}
	
    isInitialState = NO;
	
	_cardLastFourField.text = self.cardNumber.lastGroup;
	
	[_innerView addSubview:_cardLastFourField];
    
	[UIView animateWithDuration:0.200 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		_cardExpiryField.leftView.alpha = 1.0;
	} completion:nil];
	
	CGFloat difference = -(_innerView.frame.size.width - self.frame.size.width + _placeholderView.frame.size.width);
	
	[UIView animateWithDuration:0.400 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		_cardNumberField.alpha = 0.0;
		_innerView.frame = CGRectOffset(_innerView.frame, difference, 0);
    } completion:nil];
    
    [self.innerView addSubview:_cardExpiryField];
    [self.innerView addSubview:_cardCVCField];
    [_cardExpiryField becomeFirstResponder];
}

- (void)stateCardCVC
{
	if ([self.delegate respondsToSelector:@selector(paymentView:didChangeState:)]) {
		[self.delegate paymentView:self didChangeState:PKViewStateCVC];
	}
	
    [_cardCVCField becomeFirstResponder];
}

- (BOOL)isValid
{
    return [self.cardNumber isValid] && [self.cardExpiry isValid] &&
	[self.cardCVC isValidWithType:self.cardNumber.cardType];
}

- (PKCard *)card
{
    PKCard *card    = [[PKCard alloc] init];
    card.number     = [self.cardNumber string];
    card.cvc        = [self.cardCVC string];
    card.expMonth   = [self.cardExpiry month];
    card.expYear    = [self.cardExpiry year];
    
    return card;
}

-(void) setCard:(PKCard *)card {
    [self reset];
    PKCardNumber *number = [[PKCardNumber alloc] initWithString:card.number];
    self.cardNumberField.text = [number formattedString];
    [self setPlaceholderToCardType];
    
    NSString *month = [NSString stringWithFormat:@"%02d", (int)card.expMonth];
    NSString *year = [[NSString stringWithFormat:@"%lu", (unsigned long)card.expYear] substringFromIndex:2];
    
    self.cardExpiryField.text = [NSString stringWithFormat:@"%@/%@", month, year];
    self.cardCVCField.text = card.cvc;
    [self stateMeta];
    [self.cardExpiryField resignFirstResponder];
}

-(void) reset {
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setup];
    [self layoutSubviews];
}

- (void)setPlaceholderViewImage:(UIImage *)image
{
    if (![_placeholderView.image isEqual:image]) {
        __block __unsafe_unretained UIView *previousPlaceholderView = _placeholderView;
        [UIView animateWithDuration:0.25 delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
							 _placeholderView.layer.opacity = 0.0;
							 _placeholderView.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1.2);
						 } completion:^(BOOL finished) {
							 [previousPlaceholderView removeFromSuperview];
						 }];
		
        _placeholderView = nil;
        
        [self setupPlaceholderView];
        _placeholderView.image = image;
        _placeholderView.layer.opacity = 0.0;
        _placeholderView.layer.transform = CATransform3DMakeScale(0.8, 0.8, 0.8);
        [self insertSubview:_placeholderView belowSubview:previousPlaceholderView];
        [UIView animateWithDuration:0.25 delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
							 _placeholderView.layer.opacity = 1.0;
							 _placeholderView.layer.transform = CATransform3DIdentity;
						 } completion:^(BOOL finished) {}];
    }
}

- (void)setPlaceholderToCVC
{
    PKCardNumber *cardNumber = [PKCardNumber cardNumberWithString:_cardNumberField.text];
    PKCardType cardType      = [cardNumber cardType];
    
    if (cardType == PKCardTypeAmex) {
        [self setPlaceholderViewImage:[PKResourceLoader imageWithName:@"cvc-amex"]];
    } else {
        [self setPlaceholderViewImage:[PKResourceLoader imageWithName:@"cvc"]];
    }
}

- (void)setPlaceholderToCardType
{
    PKCardNumber *cardNumber = [PKCardNumber cardNumberWithString:_cardNumberField.text];
    PKCardType cardType      = [cardNumber cardType];
    NSString *cardTypeName   = @"placeholder";
    
    switch (cardType) {
        case PKCardTypeAmex:
            cardTypeName = @"amex";
            break;
        case PKCardTypeDinersClub:
            cardTypeName = @"diners";
            break;
        case PKCardTypeDiscover:
            cardTypeName = @"discover";
            break;
        case PKCardTypeJCB:
            cardTypeName = @"jcb";
            break;
        case PKCardTypeMasterCard:
            cardTypeName = @"mastercard";
            break;
        case PKCardTypeVisa:
            cardTypeName = @"visa";
            break;
        default:
            break;
    }
	
	if (self.imageStyle == PKViewImageStyleOutline) {
		cardTypeName = [NSString stringWithFormat:@"%@-outline", cardTypeName];
	}
	
    [self setPlaceholderViewImage:[PKResourceLoader imageWithName:cardTypeName]];
}

// Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:_cardCVCField]) {
        [self setPlaceholderToCVC];
    } else {
        [self setPlaceholderToCardType];
    }
    
    if ([textField isEqual:_cardNumberField] && !isInitialState) {
        [self stateCardNumber];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    if ([textField isEqual:_cardNumberField]) {
        return [self cardNumberFieldShouldChangeCharactersInRange:range replacementString:replacementString];
    }
    else if ([textField isEqual:_cardExpiryField]) {
        return [self cardExpiryShouldChangeCharactersInRange:range replacementString:replacementString];
    }
    else if ([textField isEqual:_cardCVCField]) {
        return [self cardCVCShouldChangeCharactersInRange:range replacementString:replacementString];
    }
    
    return YES;
}

- (void)pkTextFieldDidBackSpaceWhileTextIsEmpty:(PKTextField *)textField
{
    if ([textField isEqual:_cardCVCField]) {
        [self.cardExpiryField becomeFirstResponder];
	}
    else if ([textField isEqual:_cardExpiryField]) {
        [self stateCardNumber];
	}
}

- (BOOL)cardNumberFieldShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *resultString = [_cardNumberField.text stringByReplacingCharactersInRange:range withString:replacementString];
    resultString = [PKTextField textByRemovingUselessSpacesFromString:resultString];
    PKCardNumber *cardNumber = [PKCardNumber cardNumberWithString:resultString];
    
    if (![cardNumber isPartiallyValid]) {
        return NO;
	}
    
    if (replacementString.length > 0) {
        _cardNumberField.text = [cardNumber formattedStringWithTrail];
    }
	else {
        _cardNumberField.text = [cardNumber formattedString];
    }
    
    [self setPlaceholderToCardType];
    
    if ([cardNumber isValid]) {
        [self textFieldIsValid:_cardNumberField];
        [self stateMeta];
    } else if ([cardNumber isValidLength] && ![cardNumber isValidLuhn]) {
        [self textFieldIsInvalid:_cardNumberField withErrors:YES];
    } else if (![cardNumber isValidLength]) {
        [self textFieldIsInvalid:_cardNumberField withErrors:NO];
    }
    
    return NO;
}

- (BOOL)cardExpiryShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *resultString = [_cardExpiryField.text stringByReplacingCharactersInRange:range withString:replacementString];
    resultString = [PKTextField textByRemovingUselessSpacesFromString:resultString];
    PKCardExpiry *cardExpiry = [PKCardExpiry cardExpiryWithString:resultString];
    
    if (![cardExpiry isPartiallyValid]) {
		return NO;
	}
    
    // Only support shorthand year
    if ([cardExpiry formattedString].length > 5) return NO;
    
    if (replacementString.length > 0) {
        _cardExpiryField.text = [cardExpiry formattedStringWithTrail];
    } else {
        _cardExpiryField.text = [cardExpiry formattedString];
    }
    
    if ([cardExpiry isValid]) {
        [self textFieldIsValid:_cardExpiryField];
        [self stateCardCVC];
    } else if ([cardExpiry isValidLength] && ![cardExpiry isValidDate]) {
        [self textFieldIsInvalid:_cardExpiryField withErrors:YES];
    } else if (![cardExpiry isValidLength]) {
        [self textFieldIsInvalid:_cardExpiryField withErrors:NO];
    }
    
    return NO;
}

- (BOOL)cardCVCShouldChangeCharactersInRange: (NSRange)range replacementString:(NSString *)replacementString
{
    NSString *resultString = [_cardCVCField.text stringByReplacingCharactersInRange:range withString:replacementString];
    resultString = [PKTextField textByRemovingUselessSpacesFromString:resultString];
    PKCardCVC *cardCVC = [PKCardCVC cardCVCWithString:resultString];
    PKCardType cardType = [[PKCardNumber cardNumberWithString:_cardNumberField.text] cardType];
    
    // Restrict length
    if (![cardCVC isPartiallyValidWithType:cardType]) {
		return NO;
	}
    
    // Strip non-digits
    _cardCVCField.text = [cardCVC string];
    
    if ([cardCVC isValidWithType:cardType]) {
        [self textFieldIsValid:_cardCVCField];
    } else {
        [self textFieldIsInvalid:_cardCVCField withErrors:NO];
    }
    
    return NO;
}

// Validations

- (void)checkValid
{
    if ([self isValid]) {
        isValidState = YES;
		
        if ([self.delegate respondsToSelector:@selector(paymentView:withCard:isValid:)]) {
            [self.delegate paymentView:self withCard:self.card isValid:YES];
        }
    } else if (![self isValid] && isValidState) {
        isValidState = NO;
        
        if ([self.delegate respondsToSelector:@selector(paymentView:withCard:isValid:)]) {
            [self.delegate paymentView:self withCard:self.card isValid:NO];
        }
    }
}

- (void)textFieldIsValid:(UITextField *)textField {
    textField.textColor = _defaultTextAttributes[NSForegroundColorAttributeName];
    [self checkValid];
}

- (void)textFieldIsInvalid:(UITextField *)textField withErrors:(BOOL)errors {
    if (errors) {
        textField.textColor = kPKRedColor;
    } else {
        textField.textColor = _defaultTextAttributes[NSForegroundColorAttributeName];;
    }
	
    [self checkValid];
}

#pragma mark -
#pragma mark UIResponder
- (UIResponder *)firstResponderField;
{
    NSArray *responders = @[self.cardNumberField, self.cardExpiryField, self.cardCVCField];
    for (UIResponder *responder in responders) {
        if (responder.isFirstResponder) {
            return responder;
        }
    }
    
    return nil;
}

- (PKTextField *)firstInvalidField;
{
    if (![[PKCardNumber cardNumberWithString:self.cardNumberField.text] isValid]) {
        return self.cardNumberField;
	}
    else if (![[PKCardExpiry cardExpiryWithString:self.cardExpiryField.text] isValid]) {
        return self.cardExpiryField;
	}
    else if (![[PKCardCVC cardCVCWithString:self.cardCVCField.text] isValid]) {
        return self.cardCVCField;
	}
    
    return nil;
}

- (PKTextField *)nextFirstResponder;
{
    if (self.firstInvalidField) {
        return self.firstInvalidField;
	}
    
    return self.cardCVCField;
}

- (BOOL)isFirstResponder;
{
    return self.firstResponderField.isFirstResponder;
}

- (BOOL)canBecomeFirstResponder;
{
    return self.nextFirstResponder.canBecomeFirstResponder;
}

- (BOOL)becomeFirstResponder;
{
    return [self.nextFirstResponder becomeFirstResponder];
}

- (BOOL)canResignFirstResponder;
{
    return self.firstResponderField.canResignFirstResponder;
}

- (BOOL)resignFirstResponder;
{
    return [self.firstResponderField resignFirstResponder];
}

@end