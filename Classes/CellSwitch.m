//
//  CellSwitch.m
//  P5P
//
//  Created by CNPP on 11.2.2011.
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

#import "CellSwitch.h"


/*
* Helper Stack.
*/
@interface CellSwitch (Helpers)
- (void)switchValueChanged:(UISwitch*)s;
@end


/**
 * Cell Switch.
 */
@implementation CellSwitch

#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;
@synthesize switchAccessory;


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
	
	// switch
	UISwitch *switchObj = [[UISwitch alloc] initWithFrame:CGRectMake(1.0, 1.0, 20.0, 20.0)];
				
	// hammer time
	[switchObj addTarget:self action:@selector(switchValueChanged:) forControlEvents:(UIControlEventValueChanged)];
				
	// accessory
	self.switchAccessory = switchObj;
	self.accessoryView = switchAccessory;
	[switchObj release];

    // show yourself
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
	if ([self.switchAccessory isOn]) {
		self.detailTextLabel.text = NSLocalizedString(@"On",@"On");
	}
	else {
		self.detailTextLabel.text = NSLocalizedString(@"Off",@"Off");
	}

}


#pragma mark -
#pragma mark Helpers

/*
* Switch value changed.
*/
- (void)switchValueChanged:(UISwitch*)s {
	GLog();
	
	// delegate
	if (delegate != nil && [delegate respondsToSelector:@selector(cellSwitchChanged:)]) {
		[delegate cellSwitchChanged:self];
	}
}


#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
	[switchAccessory release];
    [super dealloc];
}

@end
