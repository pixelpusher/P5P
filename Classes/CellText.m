//
//  CellText.m
//  P5P
//
//  Created by CNPP on 6.3.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "CellText.h"

/**
* CellText.
*/
@implementation CellText

#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;
@synthesize label;
@synthesize text;
@synthesize placeholder;



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
	
	// fields
	self.label = @"Label";
	self.text = @"Text";
	self.placeholder = @"Placeholder";

	// accessory
	self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;


    // me myself and i
    return self;
}



#pragma mark -
#pragma mark Business Methods


/**
* Initializes the text

/**
* Creates a CellTextViewController.
*/
- (CellTextViewController*)textViewController:(CGRect)pframe {
	FLog();
	
	// controller
	CellTextViewController *textController = [[CellTextViewController alloc] initWithFrame:pframe];
	textController.delegate = self;
	return textController;
	
}

#pragma mark -
#pragma mark Business

/**
* Updates the cell.
*/
- (void)update:(BOOL)reset {
	GLog();
	if (text != nil && ! [text isEqualToString:@""]) {
		self.detailTextLabel.text = text;
	}
	else {
		self.detailTextLabel.text = placeholder;
	}
}


#pragma mark -
#pragma mark CellTextViewDelegate


/*
* Returns the title.
*/
- (NSString*)controllerTitle {
	FLog();
	return label;
}

/*
* Returns the text.
*/
- (NSString*)textValue {
	FLog();
	return text;
}

/*
* Returns the description.
*/
- (NSString*)textPlaceholder {
	FLog();
	return placeholder;
}



/*
* Updates the value.
*/
- (void)updateText:(NSString*)txt {

	// set
	self.text = txt;
	
	
	// delegate
	if (delegate != nil && [delegate respondsToSelector:@selector(cellTextChanged:)]) {
		[delegate cellTextChanged:self];
	}
}


#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
	[label release];
	[text release];
	[placeholder release];
    [super dealloc];
}




@end
