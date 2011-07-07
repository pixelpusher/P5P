//
//  CellSlider.m
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

#import "CellSlider.h"



/*
* Helper Stack.
*/
@interface CellSlider (Helpers)
- (void)sliderValueChanged:(UISlider*)s;
@end

/**
 * CellSlider.
 */
@implementation CellSlider

#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;
@synthesize sliderAccessory;


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
	
	// slider
	UISlider *sliderObj = [[UISlider alloc] initWithFrame:CGRectMake(1.0, 1.0, (self.frame.size.width/2.0)-20, 20.0)];
				
	// hammer time
	[sliderObj addTarget:self action:@selector(sliderValueChanged:) forControlEvents:(UIControlEventValueChanged)];
				
	// accessory
	self.sliderAccessory = sliderObj;
	self.accessoryView = sliderAccessory;
	[sliderObj release];

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
	
	// detail label
	self.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",sliderAccessory.value];
	
	
}

#pragma mark -
#pragma mark Helpers

/*
* Switch value changed.
*/
- (void)sliderValueChanged:(UISlider*)s {
	GLog();
	
	// delegate
	if (delegate != nil && [delegate respondsToSelector:@selector(cellSliderChanged:)]) {
		[delegate cellSliderChanged:self];
	}
}


#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
	[sliderAccessory release];
    [super dealloc];
}

@end
