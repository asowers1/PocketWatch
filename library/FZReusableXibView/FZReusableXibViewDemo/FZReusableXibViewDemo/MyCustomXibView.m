//
//  MyCustomXibView.m
//  FZReusableXibViewDemo
//
//  Created by Sheng Dong on 12/12/14.
//  Copyright (c) 2014 Fuzz Productions. All rights reserved.
//

#import "MyCustomXibView.h"


@interface MyCustomXibView ()
@property (weak, nonatomic) IBOutlet UILabel *player1;
@property (weak, nonatomic) IBOutlet UILabel *player2;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (nonatomic, strong) NSArray *possibility;
@end

@implementation MyCustomXibView


- (IBAction)goPressed:(id)sender {
    
    NSString *player1Shape = [self randomShape];
    NSString *player2Shape = [self randomShape];
    self.player1.text = player1Shape;
    self.player2.text = player2Shape;
    if ([player1Shape isEqualToString:player2Shape]) {
        self.resultLabel.text = @"Tied";
    } else if ([self firstShape:player1Shape beatsSecondShape:player2Shape]) {
        self.resultLabel.text = @"Player 1 won";
    } else {
        self.resultLabel.text = @"Player 2 won";
    }
}

- (BOOL)firstShape:(NSString *)firstShape beatsSecondShape:(NSString *)secondShape
{
    if ([firstShape isEqualToString:secondShape]) {
        return NO;
    }
    if ([firstShape isEqualToString:@"Rock"]) {
        if ([secondShape isEqualToString:@"Scissor"]) {
            return YES;
        } else {
            return NO;
        }
    } else if ([firstShape isEqualToString:@"Paper"]) {
        if ([secondShape isEqualToString:@"Rock"]) {
            return YES;
        } else {
            return NO;
        }
    } else if ([firstShape isEqualToString:@"Scissor"]) {
        if ([secondShape isEqualToString:@"Paper"]) {
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}

- (NSArray *)possibility {
    if (!_possibility) {
        _possibility = @[@"Rock", @"Paper", @"Scissor"];
    }
    return _possibility;
}

- (NSString *)randomShape {
    NSInteger randomNumber = arc4random() % self.possibility.count;
    return [self.possibility objectAtIndex:randomNumber];
}

@end
