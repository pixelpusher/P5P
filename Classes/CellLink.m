//
//  CellLink.m
//  P5P
//
//  Created by CNPP on 25.2.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

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
