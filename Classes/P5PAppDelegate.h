//
//  P5PAppDelegate.h
//  P5P
//
//  Created by CNPP on 6.1.2011.
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

