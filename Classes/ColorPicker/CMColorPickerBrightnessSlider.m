//
//  CMColorPickerBrightnessSlider.m
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

#import "CMColorPickerBrightnessSlider.h"
#import "CMColorPickerSliderGradient.h"

@interface CMColorPickerBrightnessSlider()
@property (nonatomic, retain) CMColorPickerSliderGradient *gradient;
@property (nonatomic, retain) UIImageView *sliderKnobView;
@end


@implementation CMColorPickerBrightnessSlider
@synthesize gradient;
@synthesize sliderKnobView;

- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
	{		
        // Initialization code
		
		// gradient view
		CMColorPickerSliderGradient *background = [[CMColorPickerSliderGradient alloc] initWithFrame:CGRectMake(6,
																												18,
																												26,
																												frame.size.height - 36)];		
		[self addSubview:background];
		self.gradient = background;
		[background release];		
		
		// knob view
		UIImageView *knob = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"colorPickerKnob.png"]];
		[self addSubview:knob];		
		self.sliderKnobView = knob;
		[knob release];
		
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = YES;
		self.value = 0.0;
		[self setKeyColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)dealloc 
{
	[gradient release];
	[sliderKnobView release];
    [super dealloc];
}

- (void) setKeyColor:(UIColor *)c
{
	[gradient setKeyColor:c];
}

- (CGFloat) value
{
	return value;
}

- (void) setValue:(CGFloat)val
{	
	value = MAX(MIN(val, 1.0), 0.0); //cap value to [0.0 - 1.0]
	
	// update UI
	CGFloat x = roundf((self.bounds.size.width - self.sliderKnobView.bounds.size.width) * 0.5) + self.sliderKnobView.bounds.size.width * 0.5;
	CGFloat y = roundf((1 - value) * (self.frame.size.height - 40) - self.sliderKnobView.bounds.size.height * 0.5) + self.sliderKnobView.bounds.size.height * 0.5;
	
	self.sliderKnobView.center = CGPointMake(x, y + 20);
}

- (void) mapPointToBrightness:(CGPoint)point
{
	// map a point on the slider to a value
	CGFloat val = 1 - ((point.y - 20) / (self.frame.size.height - 40)); 
	self.value = val;
	
	// raise event
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self mapPointToBrightness:[touch locationInView:self]];
	return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self mapPointToBrightness:[touch locationInView:self]];
	return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self continueTrackingWithTouch:touch withEvent:event];
}
@end
