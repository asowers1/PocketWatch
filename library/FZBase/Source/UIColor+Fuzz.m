//
//  UIColor+Fuzz.m
//  BuzzBack
//
//  Created by Fuzz Productions on 11/6/13.
//  Copyright (c) 2013 Sobits. All rights reserved.
//

#import "UIColor+Fuzz.h"

@implementation UIColor (Fuzz)


int hexValueOfChar(char c)
{
    if(c == '0')return 0;
    if(c == '1')return 1;
    if(c == '2')return 2;
    if(c == '3')return 3;
    if(c == '4')return 4;
    if(c == '5')return 5;
    if(c == '6')return 6;
    if(c == '7')return 7;
    if(c == '8')return 8;
    if(c == '9')return 9;
    if(c == 'a' || c == 'A')return 10;
    if(c == 'b' || c == 'B')return 11;
    if(c == 'c' || c == 'C')return 12;
    if(c == 'd' || c == 'D')return 13;
    if(c == 'e' || c == 'E')return 14;
    if(c == 'f' || c == 'F')return 15;
    return 0;
}

char charHexValueOfNumber(int n)
{
    if(n == 0)return '0';
    if(n == 1)return '1';
    if(n == 2)return '2';
    if(n == 3)return '3';
    if(n == 4)return '4';
    if(n == 5)return '5';
    if(n == 6)return '6';
    if(n == 7)return '7';
    if(n == 8)return '8';
    if(n == 9)return '9';
    if(n == 10)return 'a';
    if(n == 11)return 'b';
    if(n == 12)return 'c';
    if(n == 13)return 'd';
    if(n == 14)return 'e';
    if(n == 15)return 'f';
    
    if(n > 15)return 'f';
    
    return '0';
    
}






/*--------------------------------------------------------------------------------
 This expects a hexadecimal number in one of the following formats
 RGB
 RGBA
 #RGB
 #RGBA
 0xRGB
 0xRGBA
 --------------------------------------------------------------------------------*/
+(UIColor*)colorFromHexString:(NSString*)hex
{
    
    
    
    if((NSNull*)hex == [NSNull null])
    {
        return [UIColor grayColor];
    }
    if([hex length] < 6 )
    {
        return [UIColor grayColor];
    }
    
    
    if([[hex substringToIndex:2] isEqualToString:@"0x"])
    {
        hex = [hex substringFromIndex:2];
    }
    
    if([[hex substringToIndex:1] isEqualToString:@"#"])
    {
        hex = [hex substringFromIndex:1];
    }
    
    if([hex length] >= 6)
    {
        char r1 = [hex characterAtIndex:0];
        char r2 = [hex characterAtIndex:1];
        double red = 16*hexValueOfChar(r1) + hexValueOfChar(r2);
        
        
        char g1 = [hex characterAtIndex:2];
        char g2 = [hex characterAtIndex:3];
        double green  = 16*hexValueOfChar(g1) + hexValueOfChar(g2);
        
        
        char b1 = [hex characterAtIndex:4];
        char b2 = [hex characterAtIndex:5];
        double blue = 16*hexValueOfChar(b1) + hexValueOfChar(b2);
        
        
        double alpha = 255;
        if([hex length] == 8)
        {
            char a1 = [hex characterAtIndex:6];
            char a2 = [hex characterAtIndex:7];
            alpha = 16*hexValueOfChar(a1) + hexValueOfChar(a2);
            
        }
        
        return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha/255.0];
    }
    
    return [UIColor grayColor];
}


/*
 
 This needs to be tested for support with non RGB colorspaces
 such as UIColor whiteColor, blackColor, and clearColor
 
 */
-(NSString*)hexString
{
	CGFloat r,g,b,a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    
    int R   = r*255;
    int G   = g*255;
    int B   = b*255;
    int A   = a*255;
    
    char r1 = charHexValueOfNumber(R/16);
    char r2 = charHexValueOfNumber(R%16);
    NSString *red = [NSString stringWithFormat:@"%c%c", r1, r2];
    
    
    char g1 = charHexValueOfNumber(G/16);
    char g2 = charHexValueOfNumber(G%16);
    NSString *green = [NSString stringWithFormat:@"%c%c", g1, g2];
    
    
    char b1 = charHexValueOfNumber(B/16);
    char b2 = charHexValueOfNumber(B%16);
    NSString *blue = [NSString stringWithFormat:@"%c%c", b1, b2];
    
    
    char a1 = charHexValueOfNumber(A/16);
    char a2 = charHexValueOfNumber(A%16);
    NSString *alpha = [NSString stringWithFormat:@"%c%c", a1, a2];
    
    
    NSString *hexValue = [NSString stringWithFormat:@"%@%@%@%@", red, green, blue, alpha];
    return hexValue;
}




@end
