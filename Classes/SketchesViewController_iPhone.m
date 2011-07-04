//
//  SketchesViewController_iPhone.m
//  P5P
//
//  Created by CNPP on 27.1.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "SketchesViewController_iPhone.h"
#import "SketchViewController_iPhone.h"


/**
* SketchesViewController_iPhone.
*/
@implementation SketchesViewController_iPhone

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
		nbOfItemsPerPage = 4;
		gridCellWidth = 120;
		gridCellHeight = 204;
		
		// return
		return self;
	}
	
	// oh oh
	return nil;
}

@end

