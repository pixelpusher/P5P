//
//  P5PViewController_iPad.m
//  P5P
//
//  Created by CNPP on 10.2.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "P5PViewController_iPad.h"
#import "SketchesViewController_iPad.h"
#import "SketchViewController_iPad.h"
#import "CollectionsViewController_iPad.h"


/**
* P5PViewController iPad.
*/
@implementation P5PViewController_iPad


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
		self.sketchesViewController = [[SketchesViewController_iPad alloc] init];
		
		// init sketch
		self.sketchViewController = [[SketchViewController_iPad alloc] init];
		
		// init collection
		self.collectionsViewController = [[CollectionsViewController_iPad alloc] init];
		
		// return of the jedi
		return self;
	}
	
	// oh oh
	return nil;
}


@end
