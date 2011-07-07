//
//  CellRange.m
//  P5P
//
//  Created by CNPP on 3.3.2011.
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

#import "CellRange.h"


/*
* Helper Stack.
*/
@interface CellRange (Helpers)
- (void)doubleSliderValueChanged:(DoubleSlider *)slider;
@end


/**
 * CellRange.
 */
@implementation CellRange



#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;
@synthesize rangeAccessory;


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
	
	// range
	DoubleSlider *sliderObj = [[DoubleSlider alloc] initWithFrame:(CGRect)CGRectMake(1.0, 1.0, (self.frame.size.width/2.0)-20, 28.0) barHeight:28.0];
	[sliderObj addTarget:self action:@selector(doubleSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
				
	// accessory
	self.rangeAccessory = sliderObj;
	self.accessoryView = rangeAccessory;
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
	FLog();
	
	// detail label
	self.detailTextLabel.text = [NSString stringWithFormat:@"%.2f - %.2f",rangeAccessory.minSelectedValue,rangeAccessory.maxSelectedValue];
	
	// redraw accessory
	if (reset) {
		[rangeAccessory reset];
	}

}


#pragma mark -
#pragma mark Helpers

/*
* Range value changed.
*/
- (void)doubleSliderValueChanged:(DoubleSlider*)s {
	GLog();
	
	// delegate
	if (delegate != nil && [delegate respondsToSelector:@selector(cellRangeChanged:)]) {
		[delegate cellRangeChanged:self];
	}
}


#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
	[rangeAccessory release];
    [super dealloc];
}

@end
