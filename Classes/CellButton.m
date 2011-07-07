//
//  CellButton.m
//  P5P
//
//  Created by CNPP on 4.3.2011.
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

#import "CellButton.h"

/*
* Helper Stack.
*/
@interface CellButton (Helpers)
- (void)buttonTouchUpInside:(UIButton*)b;
@end


/**
 * CellButton.
 */
@implementation CellButton

#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;
@synthesize buttonAccessory;


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
	
	// self
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	self.autoresizesSubviews = YES;
	self.backgroundColor = [UIColor clearColor];
	self.opaque = YES;
	
	
	// button
	int strangeoffset = -19;
	if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
		strangeoffset = 160;
	}
	UIButton *buttonObj = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	buttonObj.frame = CGRectMake(0, 0, self.frame.size.width+strangeoffset, 45); 
	buttonObj.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	[buttonObj setTitle:@"Button" forState:UIControlStateNormal];
				
	// targets and actions
	[buttonObj addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
				
	// accessory
	self.buttonAccessory = buttonObj;
	self.accessoryView = buttonAccessory;
	[buttonObj release];

    // return
    return self;
}

/*
 * Disable highlighting of currently selected cell.
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:NO];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}


#pragma mark -
#pragma mark Business

/**
* Updates the cell.
*/
- (void)update:(BOOL)reset {
	GLog();

}


#pragma mark -
#pragma mark Helpers

/*
* Switch value changed.
*/
- (void)buttonTouchUpInside:(UIButton*)b {
	GLog();
	
	// delegate
	if (delegate != nil && [delegate respondsToSelector:@selector(cellButtonTouched:)]) {
		[delegate cellButtonTouched:self];
	}
}


#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
	//[buttonAccessory release];
    [super dealloc];
}

@end
