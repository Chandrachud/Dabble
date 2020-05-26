//
//  TestView.h
//  Sample
//
//  Created by Reddy on 7/22/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ProgressCirlceView: UIView
{
    CGFloat startAngle;
    CGFloat endAngle;
}
@property (nonatomic, retain) UIColor *circleColor;
@property (assign)  int percent;
+(NSMutableAttributedString*)getAttributedString:(int)rupees :(int)cents;

@end
