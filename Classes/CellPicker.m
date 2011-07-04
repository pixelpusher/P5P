//
//  CellPicker.m
//  P5P
//
//  Created by CNPP on 3.3.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
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