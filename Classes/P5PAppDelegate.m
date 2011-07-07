//
//  P5PAppDelegate.m
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

#import "P5PAppDelegate.h"
#import "P5PConstants.h"
#import "P5PDataParser.h"
#import "Collection.h"
#import "Sketch.h"
#import "SettingGroup.h"
#import "Setting.h"
#import "Tracker.h"


/**
 * Core Data Stack.
 */
@interface P5PAppDelegate (PrivateCoreDataStack)
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (void)populateDB;
@end


/**
 * App Delegate.
 */
@implementation P5PAppDelegate


#pragma mark -
#pragma mark Constants

// constants
NSString *STORE = @"P5P.sqlite";
NSString *STORE_DEFAULT = @"P5P_default";



#pragma mark -
#pragma mark Properties

// synthesize accessors
@synthesize window;
@synthesize rootViewController;


#pragma mark -
#pragma mark Object Methods

/*
* Init.
*/
- (id)init {
    
    // init stuff
	if ( (self = [super init])) {
		
		// fields
		samplePlayer = [[SamplePlayer alloc] init];
	}
	return self;
}



#pragma mark -
#pragma mark Application lifecycle


/*
 * Application launched.
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions { 
	NSLog(@"P5P launched.");
	
	// track
	[Tracker startTracker];
	[Tracker trackPageView:@"/"];
	
	// customize appearance
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];	
	
	// version
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *information_app_version = [userDefaults objectForKey:udInformationAppVersion];
	NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	
	// install
	if (information_app_version == nil) {
		[self install:appVersion];
	}
	// update
	else if (! [appVersion isEqualToString:information_app_version]) {
		[self update:appVersion];
	}
    
    #ifdef DEBUG
    NSLog(@"P5P develop version %@.",appVersion);
    [self populateDB];
    #endif

	
	// core data
	NSManagedObjectContext *context = [self managedObjectContext];
	if (!context) {
		// Handle the error.
	}

    
	// yes sir
    return YES;
}

/*
 * App will resign active.
 */
- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"P5P will resign active.");
	
	// track
	[Tracker dispatch];
}


/*
 * App did become active.
 */
- (void)applicationWillEnterForeground:(UIApplication *)application {
	NSLog(@"P5P will enter foreground.");
	
	// track
	[Tracker trackPageView:@"/"];
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"P5P did become active.");
}


/*
 * App will terminate.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	NSLog(@"P5P will terminate.");
}


#pragma mark -
#pragma mark Busy Business Methods

/*
 * Installes the app.
 */
- (void)install:(NSString*)appVersion {
	NSLog(@"P5P version %@ installed.",appVersion);
	
	// track
	[Tracker trackEvent:TEventApp action:@"Install" label:appVersion];
	
	// defaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	// reset user defaults
	[userDefaults setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
		
	// set version
	[userDefaults setObject:appVersion forKey:udInformationAppVersion];
    
    
    // notification sketch
    [self storeNotification:NSLocalizedString(@"↑Access the sketch settings, export and refresh above. DoubleTap top to show/hide toolbar.", @"⇑ Access the sketch settings, export and refresh above. DoubleTap top to show/hide toolbar.") type:udNoteSketch];
	
	// load data
	[self loadData];
}

/*
 * Updates the app.
 */
- (void)update:(NSString*)appVersion {
	NSLog(@"P5P updated to version %@.",appVersion);
	
	// track
	[Tracker trackEvent:TEventApp action:@"Update" label:appVersion];
	
	// defaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		
	// set version
	[userDefaults setObject:appVersion forKey:udInformationAppVersion];
    
    // note
    [self storeNotification:NSLocalizedString(@"Thanks for updating P5P - now with a new Color Picker. You may need to reset some of the sketches.",@"Thanks for updating P5P - now with a new Color Picker. You may need to reset some of the sketches.") type:udNoteApp];
	
	// load data
	[self loadData];
}


/*
* Loads the data.
*/
- (void)loadData {
	DLog();

	// path
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:STORE];
	NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:STORE_DEFAULT ofType:@"sqlite"];
	
	// remove existing db
	if ([fileManager fileExistsAtPath:storePath]) {
		NSLog(@"P5P remove existing db.");
		[fileManager removeItemAtPath:storePath error:NULL];
	}
	
	// copy default
	if (defaultStorePath) {
		NSLog(@"P5P copy default db.");
		[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
	}
	
}


/*
 * Loads the collections.
 */
- (NSMutableArray*)loadCollections {
	DLog();
	
	// fetch data request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Collection"
											  inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	
	
	// sort descriptor
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
										initWithKey:@"sort" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor,
								nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	[sortDescriptor release];
	
	// execute request
	NSError *error;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// handle the error
		NSLog(@"P5P CoreData Error\n%@\n%@", error, [error userInfo]);
	}
	
	// data
	NSMutableArray *data = [[NSMutableArray alloc] initWithArray:mutableFetchResults];
	
	// release
	[mutableFetchResults release];
	[request release];
	
	// have some collections
	return data;
}


/*
 * Loads the sketches.
 */
- (NSMutableArray*)loadSketches {
	DLog();
	
	// fetch data request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Collection"
											  inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	
	
	// sort descriptor
	NSSortDescriptor *sortSorter = [[NSSortDescriptor alloc]
										initWithKey:@"sort" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortSorter,
								nil];
	[request setSortDescriptors:sortDescriptors];
	
	// execute request
	NSError *error;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// handle the error
		NSLog(@"P5P CoreData Error\n%@\n%@", error, [error userInfo]);
	}
	
	// preferences
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	// sketches
	NSMutableArray *sketches = [[[NSMutableArray alloc] init] autorelease];
	
	// collections
	NSMutableArray *collections = [[NSMutableArray alloc] initWithArray:mutableFetchResults];
	for (Collection *collection in collections) {
	
		// disabled
		BOOL collectionDisabled = [userDefaults boolForKey:[NSString stringWithFormat:@"%@_%@",udCollectionDisabled,collection.cid]];
		if (! collectionDisabled) {
			// sketches
			NSMutableArray *collectionSketches = [NSMutableArray arrayWithArray:[collection.sketches allObjects]];
			[collectionSketches sortUsingDescriptors:sortDescriptors];
		
			// add
			[sketches addObjectsFromArray:collectionSketches];
		}
		
	}
	[collections release];
	
	// release
	[mutableFetchResults release];
	[request release];
	[sortDescriptors release];
	[sortSorter release];
	
	// back to the future
	return sketches;
}

/**
* Disables a collection.
*/
- (void)disableCollection:(NSString*)cid disabled:(BOOL)flag {
	DLog(@"collection = %@, disabled = %@",cid,flag ? @"YES" : @"NO");
	
	// track
	[Tracker trackEvent:TEventCollection action:(flag ? @"Disable" : @"Enable") label:[NSString stringWithFormat:@"%@",cid]];
	
	// preferences
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	// settings
	[userDefaults setBool:flag forKey:[NSString stringWithFormat:@"%@_%@",udCollectionDisabled,cid]];
	[userDefaults synchronize];
}

/**
 * Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark Helpers

/**
* Resets the user defaults.
*/
- (void)resetUserDefaults {
	DLog();
	
	// app version
	NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
		
	// user defaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		
	// clear defaults & set version
	[userDefaults setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
	[userDefaults setObject:appVersion forKey:udInformationAppVersion];
	[userDefaults synchronize];
	NSLog(@"P5P reset version %@.",[userDefaults objectForKey:udInformationAppVersion]);
}

/**
 * Sets a user default.
 */
- (void)setUserDefault:(NSString*)key value:(NSObject*)value {
	FLog(@"key = %@, value = %@",key,value);
		
	// user defaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	// set
	[userDefaults setObject:value forKey:key];
	[userDefaults synchronize];

}
- (void)setUserDefaultBool:(NSString*)key value:(BOOL)b {
	FLog(@"key = %@, value = %@",key,b?@"YES":@"NO");
		
	// user defaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	// set
	[userDefaults setBool:b forKey:key];
	[userDefaults synchronize];

}

/**
 * Gets a user default.
 */
- (NSObject*)getUserDefault:(NSString*)key {
	FLog(@"key = %@",key);
		
	// user defaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	// return
	NSObject *v = [userDefaults objectForKey:key];
	FLog(@"value = %@",v);
	return v;
}
- (BOOL)getUserDefaultBool:(NSString*)key {
	FLog(@"key = %@",key);
		
	// user defaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	// return
	BOOL v = [userDefaults boolForKey:key]; 
	FLog(@"value = %@",v?@"YES":@"NO");
	return v;
}


/**
 * Stores/retrieves a note.
 */
- (void)storeNotification:(NSString *)note type:(NSString *)type {
    FLog();
    
    // user defaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:note forKey:type];
    [userDefaults synchronize];
}
- (NSString*)retrieveNotification:(NSString *)type {
    FLog();
    
    // user defaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // retrieve & remove
    NSString *note = [userDefaults objectForKey:type];
    [userDefaults removeObjectForKey:type];
    [userDefaults synchronize];
    
    // return
    return note;
}


#pragma mark -
#pragma mark Core Data stack

/**
 * Returns the managed object context for the application.
 * If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	FLog();
	
	// context
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
	// store
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 * Returns the managed object model for the application.
 * If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	FLog();
	
	// model
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 * Returns the persistent store coordinator for the application.
 * If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	FLog();
	
	// existing coordinator
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
	// store path
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:STORE];
	
	// store url
    NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
	
	// options
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
							 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
							 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
	
	// init
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
		
		// something bad happend
		NSLog(@"P5P CoreData Error\n%@\n%@", error, [error userInfo]);
		
		// show info
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"Error" 
							  message:@"Could not load data. Please try to reinstall the application... Sorry about this." 
							  delegate:self 
							  cancelButtonTitle: @"Cancel"
							  otherButtonTitles:@"Quit",nil];
		[alert setTag:P5PAppAlertError];
		[alert show];    
		[alert release];
    }    
	
	// return
    return persistentStoreCoordinator;
}

/**
* Populates the db.
*/
- (void) populateDB {
	NSLog(@"P5P populate db.");
    
    // path
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:STORE];
	
	// remove existing db
	if ([fileManager fileExistsAtPath:storePath]) {
		[fileManager removeItemAtPath:storePath error:NULL];
	}

    // parser 
	NSError *parseError = nil;
	P5PDataParser *p5pParser = [[P5PDataParser alloc] initWithContext:[self managedObjectContext]];
	
	// test
    #ifdef DEBUG
    //NSURL *xmlTest = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"xml"]];
    //[p5pParser parseXMLFileAtURL:xmlTest parseError:&parseError];
    #endif
	
    // line
    NSURL *xmlLine = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"line" ofType:@"xml"]];
    [p5pParser parseXMLFileAtURL:xmlLine parseError:&parseError];
    
    // release
	[p5pParser release];
	
	// done
	NSLog(@"P5P parsed data.");
	
}



#pragma mark -
#pragma mark Audio

/**
* Sample selected.
*/
- (void)playSampleSelected {
	FLog();
	// preference
	if (! [self getUserDefaultBool:udPreferenceSoundDisabled]) {
		[samplePlayer play:SampleSelected];
	}
}





#pragma mark -
#pragma mark UIAlertViewDelegate Delegate


/*
 * Alert view button clicked.
 */
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	FLog();
	
	// determine alert
	switch ([actionSheet tag]) {
		// fatal injuries
		case P5PAppAlertFatal: {
			NSLog(@"Aus die Maus.");
			
			// abort mission
			abort();			
			break;
		}
		// bad but not so bad
		case P5PAppAlertError: {
			// cancel
			if (buttonIndex == 0) {
			}
			// quit
			else {
				NSLog(@"Aus die Maus.");
				abort();
			}
			break;
		}

		// have a break
		default:
		break;
	}
	
	
}


#pragma mark -
#pragma mark Memory management

/*
 * Memory warning.
 */
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	NSLog(@"P5P received memory warning.");
}


/*
 * Deallocates used memory.
 */
- (void)dealloc {
	GLog();
	
	// stop tracker
	[Tracker stopTracker];
	
	// release global resources
	[samplePlayer release];
    [window release];
    [super dealloc];
}

@end
