//
//  CollectionsViewController_iPhone.m
//  P5P
//
//  Created by CNPP on 24.2.2011.
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
