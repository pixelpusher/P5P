//
//  CMColorPickerWheel.m
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
#import "CMColorPickerHSWheel.h"


@interface CMColorPickerHSWheel()
@property (nonatomic, retain) UIImageView *wheelImageView;
@property (nonatomic, retain) UIImageView *wheelKnobView;
@end


@implementation CMColorPickerHSWheel
@synthesize wheelImageView;
@synthesize wheelKnobView;
@synthesize currentHSV;

- (id)initAtOrigin:(CGPoint)origin
{
    if ((self = [super initWithFrame:CGRectMake(origin.x, origin.y, 204, 204)])) 
	{
        // Initialization code
		
		// add the imageView for the color wheel
		UIImageView *wheel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pickerColorWheel.png"]];
		wheel.contentMode = UIViewContentModeTopLeft;
		wheel.frame = CGRectMake(2, 2, 200, 200);
		[self addSubview:wheel];
		self.wheelImageView = wheel;
		[wheel release];
		
		// create the knob
		UIImageView *wheelKnob = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"colorPickerKnob.png"]];
		[self addSubview:wheelKnob];
		self.wheelKnobView = wheelKnob;
		[wheelKnob release];
		
		self.userInteractionEnabled = YES;		
		self.currentHSV = HSVTypeMake(0, 0, 1); // white
		
        self.backgroundColor = [UIColor whiteColor];
		self.layer.cornerRadius = 102;		
    }
    return self;
}

- (void)dealloc 
{
	[wheelImageView release];
	[wheelKnobView release];
    [super dealloc];
}

// maps a given point in the color wheel to its corresponding hsv value
- (void) mapPointToColor:(CGPoint) point
{	
	CGPoint center = CGPointMake(self.wheelImageView.bounds.size.width * 0.5, 
								 self.wheelImageView.bounds.size.height * 0.5);
	
    double radius = self.wheelImageView.bounds.size.width * 0.5;
    
	// trig 101, find the angle between the point and the horizontal origin
	double dx = ABS(point.x - center.x);
    double dy = ABS(point.y - center.y);
    double angle = atan(dy / dx);
	
	if (isnan(angle))
		angle = 0.0;
	
	// if the point is above the center line, the angle will be 180º - angle
	if (point.x < center.x)
        angle = M_PI - angle;
	
	// if below, the angle is 360º - angle
    if (point.y > center.y)
        angle = 2.0 * M_PI - angle;
	
	// saturation is the distance
    double dist = sqrt(pow(dx, 2) + pow(dy, 2));
    double saturation = MIN(dist / radius, 1.0);
	
	// if too close to the center, snap to white
	if (dist < 10)
        saturation = 0; // snap to center		    
	
	self.currentHSV = HSVTypeMake(angle / (2.0 * M_PI), // hue goes from 0.0 to 1.0, divide angle by 2π to get the correct hue
								  saturation, 
								  1.0);

	
	// post the action event
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void) setCurrentHSV:(HSVType)hsv
{
	currentHSV = hsv;
	currentHSV.v = 1.0;
	double angle = currentHSV.h * 2.0 * M_PI;
	CGPoint center = CGPointMake(self.wheelImageView.bounds.size.width * 0.5, 
								 self.wheelImageView.bounds.size.height * 0.5);
	double radius = self.wheelImageView.bounds.size.width * 0.5;
	radius *= currentHSV.s;
	
	CGFloat x = center.x + cosf(angle) * radius;
	CGFloat y = center.y - sinf(angle) * radius;
	
	// update UI
	x = roundf(x - self.wheelKnobView.bounds.size.width * 0.5) + self.wheelKnobView.bounds.size.width * 0.5;
	y = roundf(y - self.wheelKnobView.bounds.size.height * 0.5) + self.wheelKnobView.bounds.size.height * 0.5;
	CGPoint knobCenter = CGPointMake(x + self.wheelImageView.frame.origin.x, y + self.wheelImageView.frame.origin.y);
	self.wheelKnobView.center = knobCenter;
}

- (CGFloat) hue
{
	return currentHSV.h;
}

- (CGFloat) saturation
{
	return currentHSV.s;
}

- (CGFloat) brightness
{
	return currentHSV.v;
}

#pragma mark -
#pragma mark Touches
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint mousepoint = [touch locationInView:self];
	if (!CGRectContainsPoint(self.wheelImageView.frame, mousepoint)) 
		return NO;
	
	[self mapPointToColor:[touch locationInView:self.wheelImageView]];
	return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self mapPointToColor:[touch locationInView:self.wheelImageView]];
	return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	//[self continueTrackingWithTouch:touch withEvent:event];
}

@end
