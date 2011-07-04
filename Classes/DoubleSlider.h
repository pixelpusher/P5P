//
//  DoubleSlider.h
//  Sweeter
//
//  Created by Dimitris on 23/06/2010.
//  Copyright 2010 locus-delicti.com. All rights reserved.
//


/**
* DoubleSlider.
*/
@interface DoubleSlider : UIControl {

	// Properties
	float minSelectedValue;
	float maxSelectedValue;
	float minValue;
	float maxValue;
	
	// UI
	UIImageView *minHandle;
	UIImageView *maxHandle;
	
	// Stuff
	float sliderBarHeight;
	CGColorRef bgColor;
    
    // border
    float inset;
    float border;
	
	// Flags
	BOOL dragmin;
	BOOL dragmax;
	
}

// Properties
@property float minSelectedValue;
@property float maxSelectedValue;
@property float minValue;
@property float maxValue;
@property (nonatomic, retain) UIImageView *minHandle;
@property (nonatomic, retain) UIImageView *maxHandle;

// Methods
- (id) initWithFrame:(CGRect)aFrame barHeight:(float)height;
- (id) initWithFrame:(CGRect)aFrame minValue:(float)minValue maxValue:(float)maxValue barHeight:(float)height;
- (void) reset;

@end


/*
Improvements:
 - initWithWidth instead of frame?
 - do custom drawing below an overlay layer
*/