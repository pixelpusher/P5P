//
//  P5PAppDelegate_iPhone.m
//  P5P
//
//  Created by CNPP on 27.1.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "P5PAppDelegate_iPhone.h"
#import "P5PViewController_iPhone.h"


/**
 * App Delegate iPhone.
 */
@implementation P5PAppDelegate_iPhone


#pragma mark -
#pragma mark Properties


// synthesize accessors
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle


/*
 * Application launched.
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions { 
	
	// init global app
	[super application:application didFinishLaunchingWithOptions:launchOptions];
	
	// init iPhone
	NSLog(@"P5P init iPhone.");
	
	// root view
	P5PViewController_iPhone *p5pController = [[P5PViewController_iPhone alloc] init];
	self.rootViewController = p5pController;
	[p5pController release];

	
	// configure and display the window
    [window addSubview:[rootViewController view]];
    [window makeKeyAndVisible];
	
	// success
	return YES;
}



#pragma mark -
#pragma mark Memory management

/*
 * Deallocates used memory.
 */
- (void)dealloc {
	GLog();
	
	// release resources
    [navigationController release];
	
	// release global
    [super dealloc];
}


@end
