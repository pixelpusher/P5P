//
//  CellRange.m
//  P5P
//
//  Created by CNPP on 3.3.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

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
