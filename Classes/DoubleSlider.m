//
//  DoubleSlider.m
//  Sweeter
//
//  Created by Dimitris on 23/06/2010.
//  Copyright 2010 locus-delicti.com. All rights reserved.
//

#import "DoubleSlider.h"

#define kMinHandleDistance		0.0


//define private methods
@interface DoubleSlider (PrivateMethods)
- (void)updateValues;
- (void)addToContext:(CGContextRef)context roundRect:(CGRect)rrect withRoundedCorner1:(BOOL)c1 corner2:(BOOL)c2 corner3:(BOOL)c3 corner4:(BOOL)c4 radius:(CGFloat)radius;
@end


/**
* DoubleSlider.
*/
@implementation DoubleSlider

@synthesize minSelectedValue, maxSelectedValue;
@synthesize minValue, maxValue;
@synthesize minHandle, maxHandle;



#pragma mark Object initialization

/*
* Init.
*/
- (id) initWithFrame:(CGRect)aFrame minValue:(float)aMinValue maxValue:(float)aMaxValue barHeight:(float)height {
	if ((self = [super initWithFrame:aFrame])) {
		if (aMinValue < aMaxValue) {
			minValue = aMinValue;
			maxValue = aMaxValue;
		}
		else {
			minValue = aMaxValue;
			maxValue = aMinValue;
		}
		sliderBarHeight = height;
		dragmin = NO;
		dragmax = NO;
        inset = 10;
        border = 12;
		
		self.minHandle = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slider_handle.png"]] autorelease];
		self.minHandle.center = CGPointMake(self.frame.size.width * 0.2, sliderBarHeight * 0.5);
		[self addSubview:self.minHandle];
		
		self.maxHandle = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slider_handle.png"]] autorelease];
		self.maxHandle.center = CGPointMake(self.frame.size.width * 0.8, sliderBarHeight * 0.5);
		[self addSubview:self.maxHandle];
		self.backgroundColor = [UIColor clearColor];
		bgColor = CGColorRetain([UIColor colorWithRed:69/255.0 green:119/255.0 blue:203/255.0 alpha:1.0].CGColor);
		
		//init
		[self updateValues];
	}
	return self;
}


/*
* Init.
*/
- (id) initWithFrame:(CGRect)aFrame barHeight:(float)height {
	if ((self = [super initWithFrame:aFrame])) {
		sliderBarHeight = height;
		dragmin = NO;
		dragmax = NO;
        inset = 10;
        border = 12;
		
		self.minHandle = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slider_handle.png"]] autorelease];
		self.minHandle.center = CGPointMake(self.frame.size.width * 0.2, sliderBarHeight * 0.5);
		[self addSubview:self.minHandle];
		
		self.maxHandle = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slider_handle.png"]] autorelease];
		self.maxHandle.center = CGPointMake(self.frame.size.width * 0.8, sliderBarHeight * 0.5);
		[self addSubview:self.maxHandle];
		self.backgroundColor = [UIColor clearColor];
		bgColor = CGColorRetain([UIColor colorWithRed:69/255.0 green:119/255.0 blue:203/255.0 alpha:1.0].CGColor);
		
		//init
		[self updateValues];
	}
	return self;
}


/*
* Processing reset.
*/
- (void)reset {
	GLog();
    
    // reset
    float span = maxValue - minValue; //FIX: this should be cached
    float range = self.frame.size.width-2*border;
    float fmin = border + ( (self.minSelectedValue-minValue) /span)*range;
    float fmax = border + ( (self.maxSelectedValue-minValue) /span)*range;
    
    // handles
    self.minHandle.center = CGPointMake(fmin, self.minHandle.center.y);
	self.maxHandle.center = CGPointMake(fmax, self.maxHandle.center.y);	
    
    
     /*
    // update
	float span = maxValue - minValue; //FIX: this should be cached
    float range = self.frame.size.width-2*border;
    
	self.minSelectedValue = minValue + ((self.minHandle.center.x-border) / range) * span;
	self.maxSelectedValue = minValue + ((self.maxHandle.center.x-border) / range) * span;
    float fmin = ((self.minSelectedValue - minValue)/span*range)+border;
    float fmax = ((self.maxSelectedValue - minValue)/span*range)+border;
	
	// handles
	self.minHandle.center = CGPointMake(fmin, self.minHandle.center.y);
	self.maxHandle.center = CGPointMake(fmax, self.maxHandle.center.y);	
     
    */
	
	//init
	[self updateValues];
	
	//redraw
	[self setNeedsDisplay];
	
}

#pragma mark Touch tracking

/*
* Track.
*/
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
	DLog();
	
	// touch
	CGPoint touchPoint = [touch locationInView:self];
	
	// hitarea
	float hitsize = 10;
	CGRect minHitarea = CGRectMake(self.minHandle.frame.origin.x-hitsize, self.minHandle.frame.origin.y-hitsize, self.minHandle.frame.size.width+2*hitsize, self.minHandle.frame.size.height+2*hitsize);
	CGRect maxHitarea = CGRectMake(self.maxHandle.frame.origin.x-hitsize, self.maxHandle.frame.origin.y-hitsize, self.maxHandle.frame.size.width+2*hitsize, self.maxHandle.frame.size.height+2*hitsize);
	
	// determine handle
	if ( CGRectContainsPoint(minHitarea, touchPoint) ) {
		dragmin = YES;
	}
	else if ( CGRectContainsPoint(maxHitarea, touchPoint) ) {
		dragmax = YES;
	}
	
	// avoid conflicts
	if (dragmin && self.maxHandle.frame.origin.x < 2*hitsize) {
		dragmin = NO;
		dragmax = YES;
	}
	
	// super
	return [super beginTrackingWithTouch:touch withEvent:event];
}
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {

	// touch
	CGPoint touchPoint = [touch locationInView:self];
	if (dragmin && touchPoint.x) {
		
		// update
		if (touchPoint.x < self.maxHandle.center.x - kMinHandleDistance && touchPoint.x >= border) {
			self.minHandle.center = CGPointMake(touchPoint.x, self.minHandle.center.y);
			[self updateValues];
		}
		// snap
		else if (touchPoint.x < border) {
			self.minHandle.center = CGPointMake(border, self.minHandle.center.y);
			[self updateValues];
		}
	}
	else if (dragmax) {
	
		// update
		if (touchPoint.x > self.minHandle.center.x + kMinHandleDistance && touchPoint.x <= self.frame.size.width-border) {
			self.maxHandle.center = CGPointMake(touchPoint.x, self.maxHandle.center.y);
			[self updateValues];
		}
		else if (touchPoint.x > self.frame.size.width-border) {
			self.maxHandle.center = CGPointMake(self.frame.size.width-border, self.maxHandle.center.y);
			[self updateValues];
		}
	}
	// value changed 
	[self sendActionsForControlEvents:UIControlEventValueChanged];
	
	//redraw
	[self setNeedsDisplay];
	return YES;
}
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
	FLog();
	
	// flag
	dragmin = NO;
	dragmax = NO;
	
	// super
	[super endTrackingWithTouch:touch withEvent:event];

}

#pragma mark Custom Drawing

/*
* Display.
*/
- (void) drawRect:(CGRect)rect {
    
	// space cowboy
	CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
	 
	// background gradient
	size_t bg_num_locations = 3;
    CGFloat bg_locations[3] = { 0.0, 0.3, 1.0 };
    CGFloat bg_components[12] = { 
			0.60, 0.60, 0.60, 1.0,  // Start color
			0.85, 0.85, 0.85, 1.0,  // Mid color
			0.96, 0.96, 0.96, 1.0 }; // End color
    CGGradientRef bg_gradient = CGGradientCreateWithColorComponents(baseSpace, bg_components, bg_locations, bg_num_locations);
	
	
	// in space...
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
	
	
	// clear
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextClearRect(context, self.bounds);
	
	
	
	
	// handles and range
	CGRect rect1 = CGRectMake(0, inset, self.minHandle.center.x, sliderBarHeight-2*inset);
	CGRect rect2 = CGRectMake(self.minHandle.center.x, inset, self.maxHandle.center.x - self.minHandle.center.x, sliderBarHeight-2*inset);
	CGRect rect3 = CGRectMake(self.maxHandle.center.x, inset, self.frame.size.width - self.maxHandle.center.x, sliderBarHeight-2*inset);
	
	
	
	// gradient start/end
	CGContextSaveGState(context);
    CGPoint bg_startPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds));
    CGPoint bg_endPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
	
	
	//add the right/left corners
	[self addToContext:context roundRect:rect3 withRoundedCorner1:NO corner2:YES corner3:YES corner4:NO radius:5.0f];
	[self addToContext:context roundRect:rect1 withRoundedCorner1:YES corner2:NO corner3:NO corner4:YES radius:5.0f];
	
	
	// draw background
    CGContextClip(context);
    CGContextDrawLinearGradient(context, bg_gradient, bg_startPoint, bg_endPoint, 0);
	CGGradientRelease(bg_gradient), bg_gradient = NULL;

	
	
	//draw middle rect
    CGContextRestoreGState(context);
	CGContextSetFillColorWithColor(context, bgColor);
	CGContextFillRect(context, rect2);
	
		
	// super
	[super drawRect:rect];
}


/*
* Edge.
*/
- (void)addToContext:(CGContextRef)context roundRect:(CGRect)rrect withRoundedCorner1:(BOOL)c1 corner2:(BOOL)c2 corner3:(BOOL)c3 corner4:(BOOL)c4 radius:(CGFloat)radius {	
	CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
	
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, c1 ? radius : 0.0f);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, c2 ? radius : 0.0f);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, c3 ? radius : 0.0f);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, c4 ? radius : 0.0f);
}


#pragma mark Helper

/*
* Update.
*/
- (void)updateValues {
	
	// update
	float span = maxValue - minValue; //FIX: this should be cached
    float range = self.frame.size.width-2*border;
	self.minSelectedValue = minValue + ((self.minHandle.center.x-border) / range) * span;
	self.maxSelectedValue = minValue + ((self.maxHandle.center.x-border) / range) * span;

}


#pragma mark Memory

/*
* Dealloc.
*/
- (void) dealloc {
	self.minHandle = nil;
	self.maxHandle = nil;
	[super dealloc];
}

@end