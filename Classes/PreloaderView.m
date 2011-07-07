//
//  PreloaderView.m
//  P5P
//
//  Created by CNPP on 25.2.2011.
//  Copyright Beat Raess 2011. All rights reserved.
//
//  This file is part of P5P.
//  
//  P5P is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//  
//  P5P is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//  
//  You should have received a copy of the GNU General Public License
//  along with P5P.  If not, see www.gnu.org/licenses/.

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
