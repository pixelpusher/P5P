//
//  CellInput.m
//  P5P
//
//  Created by CNPP on 3.3.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "CellInput.h"

/**
* Abstract CellInput.
*/
@implementation CellInput


#pragma mark -
#pragma mark Properties

// accessors
@synthesize key;


#pragma mark -
#pragma mark Business

/**
* Updates the cell.
*/
- (void)update:(BOOL)reset {
	GLog();
	self.detailTextLabel.text = @"";
}


#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
	[key release];
    [super dealloc];
}

@end
