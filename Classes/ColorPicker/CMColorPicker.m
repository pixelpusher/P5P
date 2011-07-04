//
//  CMColorWheelView.m
//  colorPickerTest
//
//  Created by Alex Restrepo on 4/23/10.
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
#import "CMColorPicker.h"
#import "CMColorPickerHSWheel.h"
#import "CMColorPickerBrightnessSlider.h"
#import "HSV.h"

@interface CMColorPicker()
@property (nonatomic, retain) CMColorPickerHSWheel *colorWheel;
@property (nonatomic, retain) CMColorPickerBrightnessSlider *brightnessSlider;
@end


@implementation CMColorPicker
@synthesize colorWheel;
@synthesize brightnessSlider;
@synthesize selectedColor;

- (void) setup
{
	// set the frame to a fixed 300 x 238
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 0, 0);
	self.backgroundColor = [UIColor clearColor];
	
	// HS wheel
	CMColorPickerHSWheel *wheel = [[CMColorPickerHSWheel alloc] initAtOrigin:CGPointMake(16, 16)];
	[wheel addTarget:self action:@selector(colorWheelColorChanged:) forControlEvents:UIControlEventValueChanged];
	[self addSubview:wheel];
	self.colorWheel = wheel;
	[wheel release];
	
	// brightness slider
	CMColorPickerBrightnessSlider *slider = [[CMColorPickerBrightnessSlider alloc] initWithFrame:CGRectMake(240, 
																											0,
																											38,
																											236)];
	
	[slider addTarget:self action:@selector(brightnessChanged:) forControlEvents:UIControlEventValueChanged];
	[self addSubview:slider];
	self.brightnessSlider = slider;
	[slider release];
			
	self.selectedColor = [UIColor whiteColor];//[UIColor colorWithRed:0.349 green:0.613 blue:0.378 alpha:1.000];
}

- (id)initAtOrigin:(CGPoint)origin	
{
	return [self initWithFrame:CGRectMake(origin.x, origin.y, 0, 0)];
}

- (id)initWithFrame:(CGRect)rect	
{
    if ((self = [super initWithFrame:rect])) 
	{
        // Initialization code
		[self setup];
    }
    return self;
}

- (void)dealloc 
{
	[selectedColor release];
	[colorWheel release];
	[brightnessSlider release];
    [super dealloc];
}

- (void) awakeFromNib
{
	[self setup];
}

// function to extract rgb components from a color...
// http://arstechnica.com/apple/guides/2009/02/iphone-development-accessing-uicolor-components.ars
RGBType rgbWithUIColor(UIColor *color)
{
	const CGFloat *components = CGColorGetComponents(color.CGColor);
	
	CGFloat r,g,b;
	
	switch (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor))) 
	{
		case kCGColorSpaceModelMonochrome:
			r = g = b = components[0];
			break;
		case kCGColorSpaceModelRGB:
			r = components[0];
			g = components[1];
			b = components[2];
			break;
		default:	// We don't know how to handle this model
			return RGBTypeMake(0, 0, 0);
	}
	
	return RGBTypeMake(r, g, b);
}

- (void) setSelectedColor:(UIColor *)color animated:(BOOL)animated
{
	if (animated) 
	{
		[UIView beginAnimations:nil context:nil];
		self.selectedColor = color;
		[UIView commitAnimations];
	}
	else 
	{
		self.selectedColor = color;
	}
}

- (void) setSelectedColor:(UIColor *)c
{
	[c retain];
	[selectedColor release];
	selectedColor = c;
	
	// extract rgb then hsv components
	RGBType rgb = rgbWithUIColor(c);
	HSVType hsv = RGB_to_HSV(rgb);
	
	// set the wheel and slider values.
	self.colorWheel.currentHSV = hsv;
	self.brightnessSlider.value = hsv.v;	
	
	// background color for brightness slider
	[self.brightnessSlider setKeyColor:[UIColor colorWithHue:hsv.h 
													 saturation:hsv.s
													 brightness:1.0
														  alpha:1.0]];
	
    /* HACK: don't display selected color at display
	self.colorWheel.backgroundColor = selectedColor;
     */
}

- (void) colorWheelColorChanged:(CMColorPickerHSWheel *)wheel
{
	HSVType hsv = wheel.currentHSV;
	self.selectedColor = [UIColor colorWithHue:hsv.h
									saturation:hsv.s
									brightness:self.brightnessSlider.value
										 alpha:1.0];		
	
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void) brightnessChanged:(CMColorPickerBrightnessSlider *)slider
{
	HSVType hsv = self.colorWheel.currentHSV;
	
	self.selectedColor = [UIColor colorWithHue:hsv.h
									saturation:hsv.s
									brightness:self.brightnessSlider.value
										 alpha:1.0];
	
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

// fix the frame to 300 x 238 px
- (void) setFrame:(CGRect)rect
{
	super.frame = CGRectMake(rect.origin.x, rect.origin.y, 300, 238);
}

@end
