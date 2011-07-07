//
//  CellLink.m
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

#import "CellLink.h"


/**
* CellLink.
*/
@implementation CellLink

#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;
@synthesize url;


#pragma mark -
#pragma mark TableCell Methods

/*
 * Init cell.
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
	GLog();
	
	// init cell
    self = [super initWithStyle:style reuseIdentifier:identifier];
    if (self == nil) { 
        return nil;
    }
	
	// accessory
	self.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"icon_link_external.png"]];


    // yo mamma
    return self;
}

/*
 * Don't touch this.
 */
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event  {
	FLog();
	[super touchesEnded:touches withEvent:event];
	
	// touch
	CGPoint touchLocation = [[touches anyObject] locationInView:self];
	
	// inside
	BOOL inside = NO;
	if ( CGRectContainsPoint(self.bounds, touchLocation)) {
		inside = YES;
	}
	
	
	// selected
	if (inside && delegate != nil && [delegate respondsToSelector:@selector(cellLinkSelected:)]) {
		// delegate
		[delegate cellLinkSelected:self];
	}
}



#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
    [super dealloc];
}

@end
