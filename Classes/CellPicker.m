//
//  CellPicker.m
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

#import "CellPicker.h"



/**
* CellPicker.
*/
@implementation CellPicker


#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;
@synthesize values;
@synthesize label;
@synthesize plabel;
@synthesize pvalue;
@synthesize pindex;


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
	self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;


    // show yourself
    return self;
}



#pragma mark -
#pragma mark Business Methods

/**
* Creates a CellPickerViewController.
*/
- (CellPickerViewController*)pickerViewController:(CGRect)pframe {
	FLog();
	
	// controller
	CellPickerViewController *pickerController = [[CellPickerViewController alloc] initWithFrame:pframe];
	pickerController.delegate = self;
	return pickerController;
	
}

#pragma mark -
#pragma mark Business

/**
* Updates the cell.
*/
- (void)update:(BOOL)reset {
	GLog();
	self.detailTextLabel.text = plabel;

}


#pragma mark -
#pragma mark CellPickerViewDelegate


/*
* Returns the title.
*/
- (NSString*)controllerTitle {
	DLog();
	return label;
}

/*
* Returns the picker values.
*/
- (NSMutableArray*)pickerValues {
	FLog();
	return values;
}


/*
* Returns the label.
*/
- (NSString*)pickerLabel:(NSInteger)index {
	DLog();
	PickerData *pd = [values objectAtIndex:index];
	return pd.label;
}
- (NSString*)pickerLabel {
	DLog();
	return plabel;
}


/*
* Returns the picker index.
*/
- (NSInteger)pickerIndex {
	DLog();
	return pindex;
}


/*
* Updates the value.
*/
- (void)pickedIndex:(NSInteger)index {

	// set
	PickerData *pd = [values objectAtIndex:index];
	self.pindex = pd.index;
	self.plabel = pd.label;
	self.pvalue = pd.value;
	
	
	// delegate
	if (delegate != nil && [delegate respondsToSelector:@selector(cellPickerChanged:)]) {
		[delegate cellPickerChanged:self];
	}
}


#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
	[values release];
	[label release];
	[plabel release];
	[pvalue release];
    [super dealloc];
}


@end



/**
 * PickerData.
 */
@implementation PickerData

#pragma mark -
#pragma mark Properties

// accessors
@synthesize index;
@synthesize label;
@synthesize value;


#pragma mark -
#pragma mark Object Methods

/**
* Init.
*/
- (id)initWithIndex:(NSInteger)i label:(NSString*)l value:(NSString*)v {
	GLog();
	if ((self = [super init])) {
		self.index = i;
		self.label = l;
		self.value = v;
	}
	return self;
}



#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
	
	// self
	[label release];
	[value release];
	
	// super
    [super dealloc];
}

@end