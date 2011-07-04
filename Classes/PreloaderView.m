//
//  PreloaderView.m
//  P5P
//
//  Created by CNPP on 25.2.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "PreloaderView.h"


/**
 * Preloader Stack.
 */
@interface PreloaderView (AnimationHelpers)
- (void)animationDismissPreloader;
- (void)animationDismissPreloaderDone;
- (void)resetNotes;
@end

/**
* PreloaderView.
*/
@implementation PreloaderView


#pragma mark -
#pragma mark Constants

// constants
#define kDelayTimePreloaderDismiss			1.2f
#define kAnimateTimePreloaderDismiss		0.9f


#pragma mark -
#pragma mark Object Methods

/*
 * Initialize.
 */
- (id)initWithFrame:(CGRect)frame {
	GLog();
		
	// init UIView
    self = [super initWithFrame:frame];
	
	// init self
    if (self != nil) {
		
		// preloader
		preloader = [[UIImageView alloc] initWithFrame:frame];
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			preloader.image = [UIImage imageNamed:@"Default-Portrait.png"];
		} 
		else {
			preloader.image = [UIImage imageNamed:@"Default.png"];
		}

		preloader.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		preloader.backgroundColor = [UIColor clearColor];
		preloader.contentMode = UIViewContentModeCenter;
		
		// add
		self.opaque = YES;
		self.backgroundColor = [UIColor clearColor];
		[self addSubview:preloader];

		// return
		return self;
	}
	
	// nop
	return nil;
}


#pragma mark -
#pragma mark Business Methods

/**
 * Dismisses the preloader.
 */
- (void)dismissPreloader {
	FLog();
	[self performSelector:@selector(animationDismissPreloader) withObject:nil afterDelay:kDelayTimePreloaderDismiss];
}


/*
* Animation preloader dismiss.
*/
- (void)animationDismissPreloader {
	FLog();

	// animate
	[UIView beginAnimations:@"preloader_dismiss" context:nil];
	[UIView setAnimationDuration:kAnimateTimePreloaderDismiss];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	preloader.alpha = 0.0f;
	[UIView commitAnimations];
 
	// clean it up
	[self performSelector:@selector(animationDismissPreloaderDone) withObject:nil afterDelay:kAnimateTimePreloaderDismiss];
	
}
- (void) animationDismissPreloaderDone {
	GLog();
	
	// hide
	preloader.hidden = YES;
	self.hidden = YES;
	
	// bye
	[self removeFromSuperview];
}


#pragma mark -
#pragma mark Memory Management


/*
 * Deallocates all used memory.
 */
- (void)dealloc {	
	GLog();
	
	// release
	[preloader release];
	
	// supimessage
	[super dealloc];
}

@end
