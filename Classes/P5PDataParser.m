//
//  P5PDataParser.m
//  P5P
//
//  Created by CNPP on 25.2.2011.
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

#import "P5PDataParser.h"

/**
* P5PDataParser.
*/
@implementation P5PDataParser

#pragma mark -
#pragma mark Properties

// accessors
@synthesize managedObjectContext;


#pragma mark -
#pragma mark Object 

/**
* Init.
*/
- (id)initWithContext: (NSManagedObjectContext *) managedObjContext {
	GLog();
	self = [super init];
	
	// init parser
	if (self != nil) {
		[self setManagedObjectContext:managedObjContext];
		return self;
	}	
	return nil;
}


#pragma mark -
#pragma mark Methods


/**
* Parses an xml file.
*/
- (BOOL)parseXMLFileAtURL:(NSURL *)URL parseError:(NSError **)error {
	DLog();
	BOOL result = YES;
	
	// parser
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:URL];
    [parser setDelegate:self];
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    
	// something is terribly wrong
    NSError *parseError = [parser parserError];
    if (parseError && error) {
        *error = parseError;
		result = NO;
    }
    [parser release];
	
	// hopefully return a result
	return result;
}

/**
* Clears all data.
*/
- (void)emptyDataContext {
	FLog();

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

	// delete all collections
	for (int i = 0; i < [mutableFetchResults count]; i++) {
		[managedObjectContext deleteObject:[mutableFetchResults objectAtIndex:i]];
		
	}

	
	// Update the data model effectivly removing the objects we removed above.
	if (![managedObjectContext save:&error]) {
		
		// Handle the error.
		NSLog(@"%@", [error domain]);
	}
}



#pragma mark -
#pragma mark Parser


/*
* Start Element.
*/
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	GLog();
	
	
	// set element name
    if (qName) {
        elementName = qName;
    }
	
	// P5P
	if([elementName isEqualToString:@"P5P"]) {
		//[self emptyDataContext];
		return;
	}
    
	// Collection
    if ([elementName isEqualToString:@"Collection"]) {
		
		// object
        currentCollection = (Collection*)[NSEntityDescription insertNewObjectForEntityForName:@"Collection" inManagedObjectContext:managedObjectContext];
		
		// properties
		currentCollection.cid = [attributeDict objectForKey:@"cid"];
		currentCollection.name = [attributeDict objectForKey:@"name"];
		currentCollection.meta = [attributeDict objectForKey:@"meta"];
		currentCollection.thumb = [attributeDict objectForKey:@"thumb"];
		currentCollection.lib = [attributeDict objectForKey:@"lib"];
		currentCollection.sort = [NSNumber numberWithFloat:[(NSString*)[attributeDict objectForKey:@"sort"] floatValue]];
		
		// done
        return;
    }
	// Sketch
	else if ([elementName isEqualToString:@"Sketch"]) {
	
		// object
		currentSketch = (Sketch*)[NSEntityDescription insertNewObjectForEntityForName:@"Sketch" inManagedObjectContext:managedObjectContext];
		
		// properties
		currentSketch.sid = [attributeDict objectForKey:@"sid"];
		currentSketch.sketch = [attributeDict objectForKey:@"sketch"];
		currentSketch.name = [attributeDict objectForKey:@"name"];
		currentSketch.meta = [attributeDict objectForKey:@"meta"];
		currentSketch.thumb = [attributeDict objectForKey:@"thumb"];
		currentSketch.sort = [NSNumber numberWithFloat:[(NSString*)[attributeDict objectForKey:@"sort"] floatValue]];
		
		// add the sketch to the collection
		[currentCollection addSketchesObject:currentSketch];
    } 
	// SettingGroup
	else if([elementName isEqualToString:@"SettingGroup"]) {
		
		// object
		currentSettingGroup = (SettingGroup*)[NSEntityDescription insertNewObjectForEntityForName:@"SettingGroup" inManagedObjectContext:managedObjectContext];
		
		// properties
		currentSettingGroup.gid = [attributeDict objectForKey:@"gid"];
		currentSettingGroup.name = [attributeDict objectForKey:@"name"];
		currentSettingGroup.sort = [NSNumber numberWithFloat:[(NSString*)[attributeDict objectForKey:@"sort"] floatValue]];
		
		// add setting group to sketch
		[currentSketch addSettingGroupsObject:currentSettingGroup];

	}
	// Setting
	else if([elementName isEqualToString:@"Setting"]) {
	
		// object
		Setting *currentSetting = (Setting*)[NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:managedObjectContext];
		
		// properties
		currentSetting.key = [attributeDict objectForKey:@"key"];
		currentSetting.label = [attributeDict objectForKey:@"label"];
		currentSetting.value = [attributeDict objectForKey:@"value"];
		currentSetting.type = [attributeDict objectForKey:@"type"];
		currentSetting.options = [attributeDict objectForKey:@"options"];
		currentSetting.live = [[attributeDict objectForKey:@"live"] isEqualToString:@"YES"] ? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO];
		currentSetting.sort = [NSNumber numberWithFloat:[(NSString*)[attributeDict objectForKey:@"sort"] floatValue]];
	
		// add setting to setting group
		[currentSettingGroup addSettingsObject:currentSetting];

	}
	// Setting
	else if([elementName isEqualToString:@"Default"]) {
	
		// object
		Default *currentDefault = (Default*)[NSEntityDescription insertNewObjectForEntityForName:@"Default" inManagedObjectContext:managedObjectContext];
		
		// properties
		currentDefault.key = [attributeDict objectForKey:@"key"];
		currentDefault.value = [attributeDict objectForKey:@"value"];
	
		// add setting to setting group
		[currentSketch addDefaultsObject:currentDefault];

	}
}


/*
* End Element.
*/
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {  
	GLog();
	
	// set element name
    if (qName) {
        elementName = qName;
    }
    
	// save changes to object model
	if ([elementName isEqualToString:@"Collection"]) {
	
		// sanity check
		if(currentCollection != nil){
			NSError *error;
			
			// store what we imported already
			if (![managedObjectContext save:&error]) {
				
				// handle the error
				NSLog(@"%@", [error domain]);
			}
		}
    }
}


/*
* Handle content.
*/
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	GLog();
	// nothing to do today
}


#pragma mark -
#pragma mark Memory Management

/*
* Deallocate used memory.
*/
-(void)dealloc {
	GLog();
	[managedObjectContext release];
	[super dealloc];
}



@end
