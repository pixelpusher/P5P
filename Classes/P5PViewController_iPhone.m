//
//  P5PViewController_iPhone.m
//  P5P
//
//  Created by CNPP on 10.2.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "P5PViewController_iPhone.h"
#import "CollectionsViewController_iPhone.h"
#import "SketchesViewController_iPhone.h"
#import "SketchViewController_iPhone.h"


/**
* P5PViewController iPhone.
*/
@implementation P5PViewController_iPhone


#pragma mark -
#pragma mark Object Methods

/**
* Init.
*/
- (id)init {
	
	// init super
	if (self = [super init]) {
		FLog();
	
		// init sketches
		self.sketchesViewController = [[SketchesViewController_iPhone alloc] init];
		
		// init sketch
		self.sketchViewController = [[SketchViewController_iPhone alloc] init];
		
		// init collection
		self.collectionsViewController = [[CollectionsViewController_iPhone alloc] init];
		
		// return of the jedi
		return self;
	}
	
	// oh oh
	return nil;
}

@end
