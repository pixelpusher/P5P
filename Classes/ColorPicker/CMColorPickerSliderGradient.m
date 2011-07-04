//
//  CMColorPickerSliderGradient.m
//  colorPickerTest
//
//  Created by Alex Restrepo on 4/25/10.
//  Copyright 2010 Colombiamug/KZLabs. All rights reserved.
//
//  This code is released under the creative commons attribution-share alike licence, meaning:
//
//	Attribution - You must attribute the work in the manner specified by the author or licensor 
//	(but not in any way that suggests that they endorse you or your use of the work).
//	In this case, simple credit somewhere in your app or documentation will suffice.
//
//	Share Alike - If you alter, transform, or build upon this work, you may distribute the resulting
//	work only under the same, similar or a compatible license.
//	Simply put, if you improve upon it, share!
//
//	http://creativecommons.org/licenses/by-sa/3.0/us/
//

#import <QuartzCore/QuartzCore.h>
#import "CMColorPickerSliderGradient.h"


@implementation CMColorPickerSliderGradient

+ (Class)layerClass
{
	return [CAGradientLayer class];
}

- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
	{
		CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
		gradientLayer.cornerRadius = 3.0;
		gradientLayer.borderWidth = 2.0;
		gradientLayer.borderColor = [[UIColor whiteColor] CGColor];
				
		self.userInteractionEnabled = NO;
    }
    return self;
}

- (void) dealloc
{
	[super dealloc];
}

- (void) setKeyColor:(UIColor *)c
{
	CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;	
	
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue
					 forKey:kCATransactionDisableActions];
	gradientLayer.colors =  [NSArray arrayWithObjects:	 
							 (id)c.CGColor,
							 (id)[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.000].CGColor,		 		 
							 nil];
	[CATransaction commit];
}

@end
