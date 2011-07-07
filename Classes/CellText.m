//
//  CellText.m
//  P5P
//
//  Created by CNPP on 6.3.2011.
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
