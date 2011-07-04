//
//  P5PAppDelegate_iPad.m
//  P5P
//
//  Created by CNPP on 27.1.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "P5PAppDelegate_iPad.h"
#import "P5PViewController_iPad.h"


/**
 * App Delegate iPad.
 */
@implementation P5PAppDelegate_iPad



#pragma mark -
#pragma mark Application lifecycle


/*
 * Application launched.
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions { 

	// init global app
	[super application:application didFinishLaunchingWithOptions:launchOptions];
	
	// init iPad
	NSLog(@"P5P init iPad.");
	
	// root view
	P5PViewController_iPad *p5pController = [[P5PViewController_iPad alloc] init];
	self.rootViewController = p5pController;
	[p5pController release];

	
	// configure and display the window
    [window addSubview:[rootViewController view]];
    [window makeKeyAndVisible];
	
	// yes my dear
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
    [rootViewController release];
	
	// release global
    [super dealloc];
}


@end
