//
//  P5PAppDelegate.h
//  P5P
//
//  Created by CNPP on 6.1.2011.
//  Copyright Beat Raess 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SamplePlayer.h"


// alerts
enum {
    P5PAppAlertFatal,
	P5PAppAlertError
} P5PAppAlert;

/**
 * App Delegate.
 */
@interface P5PAppDelegate : NSObject <UIApplicationDelegate, UIAlertViewDelegate> {
	
	// global ui
	UIWindow *window;
	
	// controller
	UIViewController *rootViewController;
	
	// core data
	NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	
	// audio
	SamplePlayer *samplePlayer;
    
}

// Properties
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIViewController *rootViewController;

// Business Methods
- (void)loadData;
- (NSMutableArray*)loadSketches;
- (NSMutableArray*)loadCollections;
- (void)disableCollection:(NSString*)cid disabled:(BOOL)flag;
- (NSString *)applicationDocumentsDirectory;
- (void)update:(NSString*)appVersion;
- (void)install:(NSString*)appVersion;


// Helpers
- (void)resetUserDefaults;
- (void)setUserDefault:(NSString*)key value:(NSObject*)value;
- (void)setUserDefaultBool:(NSString*)key value:(BOOL)b;
- (NSObject*)getUserDefault:(NSString*)key;
- (BOOL)getUserDefaultBool:(NSString*)key;
- (void)storeNotification:(NSString*)note type:(NSString*)type;
- (NSString*)retrieveNotification:(NSString*)type;


// Audio
- (void)playSampleSelected;

@end

