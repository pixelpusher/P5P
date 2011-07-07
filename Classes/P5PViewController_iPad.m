//
//  P5PViewController_iPad.m
//  P5P
//
//  Created by CNPP on 10.2.2011.
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
