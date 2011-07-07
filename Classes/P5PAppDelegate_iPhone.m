//
//  P5PAppDelegate_iPhone.m
//  P5P
//
//  Created by CNPP on 27.1.2011.
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
