//
//  P5PViewController.m
//  P5P
//
//  Created by CNPP on 10.2.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "P5PViewController.h"
#import "P5PAppDelegate.h"
#import "P5PConstants.h"
#import "SketchesViewController.h"
#import "SketchViewController.h"
#import "CollectionsViewController.h"
#import "PreloaderView.h"
#import "NoteView.h"



/**
 * P5P Stack.
 */
@interface P5PViewController (AnimationHelpers)
- (void)animationNavigateToSketchDone;
- (void)animationNavigateToRootDone;
- (void)animationOpenCollectionsDone;
- (void)animationCloseCollectionsDone;
@end

@interface P5PViewController (GestureHelpers)
- (void)gestureModeCollectionsTap:(UITapGestureRecognizer*)recognizer;
@end


/**
* P5PViewController.
*/
@implementation P5PViewController


#pragma mark -
#pragma mark Constants

// constants
#define kAnimateTimeNavigateSketch	1.2f
#define kAnimateTimeNavigateRoot	0.6f

#define kOffsetCollection			115.0f
#define kAnimateOpacityCollection	0.3f
#define kAnimateTimeCollectionOpen	0.36f
#define kAnimateTimeCollectionClose	0.18f


#pragma mark -
#pragma mark Properties

// accessors
@synthesize sketchesViewController;
@synthesize sketchViewController;
@synthesize collectionsViewController;
@synthesize modeCollections;


#pragma mark -
#pragma mark Object Methods

/**
* Init.
*/
- (id)init {
	
	// init super
	if (self = [super init]) {
		GLog();
	
		// field defaults
		self.modeCollections = NO;
		
		// return
		return self;
	}
	
	// nil not nile
	return nil;
}


#pragma mark -
#pragma mark View lifecycle

/*
* Loads the view.
*/
-(void)loadView {
	[super loadView];
	FLog();

	// blanc view
	self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
	self.view.backgroundColor = [UIColor colorWithRed:255.0/236.0 green:255.0/236.0 blue:255.0/228.0 alpha:1.0];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	
	// prepare controlers
	sketchesViewController.delegate = self;
	sketchViewController.delegate = self;
	collectionsViewController.delegate = self;

	
	// prepare views
	CGRect sframe = self.view.bounds;
	sketchesViewController.view.frame = CGRectMake(sframe.origin.x, sframe.origin.y, sframe.size.width, sframe.size.height);
	sketchesViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	
	sketchViewController.view.frame = CGRectMake(sframe.origin.x, sframe.origin.y, sframe.size.width, sframe.size.height);
	sketchViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	sketchViewController.view.hidden = YES;
	
	collectionsViewController.view.frame = CGRectMake(sframe.origin.x, sframe.size.height-kOffsetCollection, sframe.size.width, kOffsetCollection);
	collectionsViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	collectionsViewController.view.hidden = YES;
	
	
	// gestures
	gestureModeCollectionsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureModeCollectionsTap:)];
	[gestureModeCollectionsTap setNumberOfTapsRequired:1];

	
 
	// add view
	[self.view addSubview:sketchViewController.view];
	[self.view sendSubviewToBack:sketchViewController.view];
	[self.view addSubview:collectionsViewController.view];
	[self.view sendSubviewToBack:collectionsViewController.view];
	
	// show default view controller
	[self.view addSubview:sketchesViewController.view];
	[self.view bringSubviewToFront:sketchesViewController.view];
	[sketchesViewController viewWillAppear:NO];
	
	// note
	NoteView *nv = [[NoteView alloc] initWithFrame:self.view.frame];
	[nv setAutoresizingMask: (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight) ];
	
	// set and add to view 
	note = [nv retain];
	[self.view addSubview:note];
    [self.view bringSubviewToFront:note];
	[nv release];
	
	// preloader
	PreloaderView *pl = [[PreloaderView alloc] initWithFrame:self.view.frame];
	preloader = [pl retain];
	[self.view addSubview:preloader];
	[self.view bringSubviewToFront:preloader];
	[pl release];
	
	// preload page
	[sketchViewController loadSketch];
}

/*
 * Prepares the view.
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	FLog();
    
    // show sketch notification
    NSString *appNotification = (NSString*) [(P5PAppDelegate*)[[UIApplication sharedApplication] delegate] retrieveNotification:udNoteApp];
    if (appNotification) {
        [note notificationInfo:appNotification];
        [note showNotificationAfterDelay:3];
    }
    
}


#pragma mark -
#pragma mark Rotation support

/*
* Rotate is the new black.
*/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}


#pragma mark -
#pragma mark Gesture Recognizer.

/*
* Sketches Tap.
*/
- (void)gestureModeCollectionsTap:(UITapGestureRecognizer*)recognizer {
	FLog();
	
	// close
	[self closeCollections];
}


#pragma mark -
#pragma mark P5PDelegate

/**
* Shows the sketch view.
*/
- (void)navigateToSketch:(Sketch*)sketch {
	DLog();
	
	// check mode
	if (self.modeCollections) {
		return;
	}
	
	// prepare controllers
	sketchViewController.sketch = sketch;
	[sketchViewController viewWillAppear:YES];
	[sketchesViewController viewWillDisappear:YES];
 
	// prepare view
	sketchViewController.view.alpha = 0.0f;
	sketchViewController.view.hidden = NO;
 
	// animate
	[UIView beginAnimations:@"navigate_sketch" context:nil];
	[UIView setAnimationDuration:kAnimateTimeNavigateSketch];
		
		// animate sketch
		sketchViewController.view.alpha = 1.0f;
		
		// animate sketches
		sketchesViewController.view.alpha = 0.0f;
	[UIView commitAnimations];
 
	// clean it up
	[self performSelector:@selector(animationNavigateToSketchDone) withObject:nil afterDelay:kAnimateTimeNavigateSketch];
}
- (void)animationNavigateToSketchDone {
	GLog();
	
	// sketches view
	[sketchesViewController viewDidDisappear:YES];
	[sketchesViewController.view setHidden:YES];
	[self.view sendSubviewToBack:sketchesViewController.view];
	
	// sketch view
	[sketchViewController viewDidAppear:YES];
	[self.view bringSubviewToFront:sketchViewController.view];
}


/**
* Shows the sketches view.
*/
- (void)navigateToRoot {
	DLog();
	
	// check mode
	if (self.modeCollections) {
		return;
	}
	
	// prepare controllers
	[sketchesViewController viewWillAppear:YES];
	[sketchViewController viewWillDisappear:YES];
 
	// prepare view
	sketchesViewController.view.alpha = 0.0f;
	sketchesViewController.view.hidden = NO;
 
	// animate
	[UIView beginAnimations:@"navigateo_root" context:nil];
	[UIView setAnimationDuration:kAnimateTimeNavigateRoot];
	
		// animate sketches
		sketchesViewController.view.alpha = 1.0f;
		
		// animate sketch
		sketchViewController.view.alpha = 0.0f;
		
	[UIView commitAnimations];
 
	// clean it up
	[self performSelector:@selector(animationNavigateToRootDone) withObject:nil afterDelay:kAnimateTimeNavigateRoot];
}
- (void)animationNavigateToRootDone {
	GLog();
	
	// sketch view
	[sketchViewController viewDidDisappear:YES];
	[sketchViewController.view setHidden:YES];
	[self.view sendSubviewToBack:sketchViewController.view];
	
	// sketches view
	[sketchesViewController viewDidAppear:YES];
	[self.view bringSubviewToFront:sketchesViewController.view];
}

/**
* Toggles the collections view.
*/
- (void)toggleCollections {
	DLog();
	// depeche mode
	if (modeCollections) {
		[self closeCollections];
	}
	else {
		[self openCollections];
	}

}

/**
* Shows the collections view.
*/
- (void)openCollections {
	DLog();
	
	// mode
	[self setModeCollections:YES];
	[sketchesViewController.view addGestureRecognizer:gestureModeCollectionsTap];
	
	// prepare controllers
	[collectionsViewController viewWillAppear:YES];
	[self.view bringSubviewToFront:sketchesViewController.view];
 
	// prepare view
	sketchesViewController.view.alpha = 1.0;
	collectionsViewController.view.hidden = NO;
 
	// animate
	[UIView beginAnimations:@"collection_open" context:nil];
	[UIView setAnimationDuration:kAnimateTimeCollectionOpen];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];

		// animate sketches
		CGPoint center = sketchesViewController.view.center;
		center.y -= kOffsetCollection;
		sketchesViewController.view.center = center;
		sketchesViewController.view.alpha = kAnimateOpacityCollection;

	
	[UIView commitAnimations];
 
	// clean it up
	[self performSelector:@selector(animationOpenCollectionsDone) withObject:nil afterDelay:kAnimateTimeCollectionOpen];
}
- (void)animationOpenCollectionsDone {
	GLog();
	
	// collections view
	[collectionsViewController viewDidAppear:YES];
	[self.view bringSubviewToFront:collectionsViewController.view];
}


/**
* Hides the collections view.
*/
- (void)closeCollections {
	DLog();
	
	// reload
	[sketchesViewController reloadSketches];
	
	// prepare controllers
	[collectionsViewController viewWillDisappear:YES];
	[self.view bringSubviewToFront:sketchesViewController.view];
	[sketchesViewController viewWillAppear:YES];
 
	// prepare view
	sketchesViewController.view.alpha = kAnimateOpacityCollection;
 
	// animate
	[UIView beginAnimations:@"collection_close" context:nil];
	[UIView setAnimationDuration:kAnimateTimeCollectionClose];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	
		// animate sketches
		CGPoint center = sketchesViewController.view.center;
		center.y += kOffsetCollection;
		sketchesViewController.view.center = center;
		sketchesViewController.view.alpha = 1.0f;

		
	[UIView commitAnimations];
 
	// clean it up
	[self performSelector:@selector(animationCloseCollectionsDone) withObject:nil afterDelay:kAnimateTimeCollectionClose];
}
- (void)animationCloseCollectionsDone {
	GLog();
	
	// collections view
	[collectionsViewController viewDidDisappear:YES];
	[collectionsViewController.view setHidden:YES];
	
	// sketches
	[collectionsViewController viewDidAppear:YES];
	
	
	// mode
	[sketchesViewController.view removeGestureRecognizer:gestureModeCollectionsTap];
	[self setModeCollections:NO];
}




/**
* Shows the sketches view.
*/
- (void)preloaded {
	NSLog(@"P5P sketches preloaded.");
	
	// dismiss preloader
	[preloader dismissPreloader];
}


#pragma mark -
#pragma mark Memory management

/*
 * Deallocates used memory.
 */
- (void)dealloc {
	GLog();
	
	// remove
	[sketchesViewController viewWillDisappear:NO];
	[sketchesViewController.view removeFromSuperview];
	[sketchesViewController viewDidDisappear:NO];
	
	[sketchViewController viewWillDisappear:NO];
	[sketchViewController.view removeFromSuperview];
	[sketchViewController viewDidDisappear:NO];
	
	[collectionsViewController viewWillDisappear:NO];
	[collectionsViewController.view removeFromSuperview];
	[collectionsViewController viewDidDisappear:NO];
	
	// gestures
	[gestureModeCollectionsTap release];

	
	// release resources
    [sketchesViewController release];
	[sketchViewController release];
	[collectionsViewController release];
	
	// release global
    [super dealloc];
}


@end