//
//  P5PDataParser.h
//  P5P
//
//  Created by CNPP on 25.2.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "Collection.h"
#import "Sketch.h"
#import "SettingGroup.h"
#import "Setting.h"
#import "Default.h"


/**
* P5PDataParser.
*/
@interface P5PDataParser : NSObject <NSXMLParserDelegate> {
	
	// CoreData
	NSManagedObjectContext *managedObjectContext;
	
	// Parser
	NSMutableString *contentsOfCurrentProperty;
	
	// Data
	Collection *currentCollection;
	Sketch *currentSketch;
	SettingGroup *currentSettingGroup;

}

// Properties
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;

// Methods
-(id) initWithContext: (NSManagedObjectContext *) managedObjContext;
-(BOOL)parseXMLFileAtURL:(NSURL *)URL parseError:(NSError **)error;
-(void) emptyDataContext;

@end
