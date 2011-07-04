//
//  Tracker.h
//  P5P
//
//  Created by CNPP on 17.3.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <Foundation/Foundation.h>

// Categories
#define TEventApp			@"App"	
#define TEventSketch		@"Sketch"
#define TEventCollection	@"Collection"	
#define TEventSettings		@"Settings"	
#define TEventExport		@"Export"
#define TEventInfo			@"Info"
#define TEventRecommend		@"Recommend"	
#define TEventFeedback		@"Feedback"	
#define TEventCredit		@"Credit"	


//  Variables
enum {
    TrackerVariableDevice,
	TrackerVariableIOS
} TrackerVariables;


/**
* Tracker.
*/
@interface Tracker : NSObject {

}
// Class Methods
+ (void)startTracker;
+ (void)stopTracker;
+ (void)dispatch;
+ (void)trackPageView:(NSString*)page;
+ (void)trackEvent:(NSString*)category action:(NSString*)action label:(NSString*)label;


@end
