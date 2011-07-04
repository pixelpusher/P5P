//
//  CollectionsViewController_iPhone.m
//  P5P
//
//  Created by CNPP on 24.2.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "CollectionsViewController_iPhone.h"


/**
* CollectionsViewController_iPhone.
*/
@implementation CollectionsViewController_iPhone

#pragma mark -
#pragma mark Object Methods

/**
* Init.
*/
- (id)init {
	
	// init super
	if (self = [super init]) {
		GLog();
	
		// field defaults
		nbOfItemsPerPage = 3;
		gridCellWidth = 107;
		
		// return
		return self;
	}
	
	// the nil is in egypt
	return nil;
}

@end
