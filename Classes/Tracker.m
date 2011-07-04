//
//  Tracker.m
//  P5P
//
//  Created by CNPP on 17.3.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "Tracker.h"
#import "APIKeys.h"
#import "GANTracker.h"


// Dispatch period in seconds
static const NSInteger kGANDispatchPeriodSec = 20;


/**
* Tracker.
*/
@implementation Tracker



#pragma mark -
#pragma mark Class Methods

/**
* Starts/stops the tracker.
*/
+ (void)startTracker {
	
	// type
	NSString *type = @"iPad";
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)	{
		// iphone
		type = @"iPhone";
	}
	FLog("device %@",type);
	
	// version
	UIDevice *device = [UIDevice currentDevice];
	NSString *version = [device systemVersion];
	
	// track
	DLog("device %@ version %@",type,version);
	
	#ifndef DEBUG
	// shared tracker
	[[GANTracker sharedTracker] startTrackerWithAccountID:kGoogleAnalytics
                                        dispatchPeriod:kGANDispatchPeriodSec
                                              delegate:nil];
											  
											  
	// device variable
	NSError *error;
	if (![[GANTracker sharedTracker] setCustomVariableAtIndex:TrackerVariableDevice+1 name:@"device" value:type scope:kGANSessionScope withError:&error]) {
		DLog(@"P5P error in setting device variable");
	}
	
	// ios variable
	if (![[GANTracker sharedTracker] setCustomVariableAtIndex:TrackerVariableIOS+1 name:@"ios" value:version scope:kGANSessionScope withError:&error]) {
		DLog(@"P5P error in setting ios variable");
	}
	#endif
}
+ (void)stopTracker {
	DLog();
	
	#ifndef DEBUG
	// stop it
	[[GANTracker sharedTracker] stopTracker];
	#endif
}

/**
* Dispatch events.
*/
+ (void)dispatch {
	FLog();
	
	#ifndef DEBUG
	// dispatch
	[[GANTracker sharedTracker] dispatch];
	#endif
}


/**
* Tracks a page view.
*/
+ (void)trackPageView:(NSString*)page {
	DLog(@"%@",page);
	
	#ifndef DEBUG
	// page view
	NSError *error;
	if (![[GANTracker sharedTracker] trackPageview:page withError:&error]) {
		// Handle error here
	}
	#endif
}

/**
* Tracks an event.
*/
+ (void)trackEvent:(NSString*)category action:(NSString*)action label:(NSString*)label {
	DLog(@"%@ %@ %@",category,action,label);
	
	#ifndef DEBUG
	// event
	NSError *error;
	if (![[GANTracker sharedTracker] trackEvent:category action:action label:label value:-1 withError:&error]) {
		// Handle error here
	}
	#endif
}


@end
