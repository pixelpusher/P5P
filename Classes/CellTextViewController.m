//
//  CellTextViewController.m
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

#import "CellTextViewController.h"


/**
* CellTextViewController.
*/
@implementation CellTextViewController


#pragma mark -
#pragma mark Properties

// accessors 
@synthesize textField;


#pragma mark -
#pragma mark Object Methods

/**
* Init with frame.
*/
- (id)initWithFrame:(CGRect) frame {
    DLog();
    
    // init
	if ((self = [super init])) {
	
		// view
		self.view = [[UIView alloc] initWithFrame:frame];
		self.contentSizeForViewInPopover = CGSizeMake(frame.size.width, frame.size.height);
		
        // remove background
        self.view.backgroundColor = [UIColor clearColor];
        self.view.opaque = YES;
		
		// ipad
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            // background pattern
            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_texture.png"]];
        }

		
		// text field
		UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(10,20,self.view.frame.size.width-20,40)];
		tf.delegate = self;
		tf.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[tf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
		[tf setBorderStyle:UITextBorderStyleRoundedRect];
		[tf setReturnKeyType:UIReturnKeyDone];
		[tf setClearButtonMode:UITextFieldViewModeWhileEditing];
		[tf setOpaque:YES];
		[tf setBackgroundColor:[UIColor clearColor]];
		
		// add to view
		self.textField = tf;
		[self.view addSubview:textField];
		[tf release];
	}
	return self;
}


#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;


#pragma mark -
#pragma mark View lifecycle


/*
* Prepares the view.
*/
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	DLog();
	
	// title
	self.title = [delegate controllerTitle];
	
	// text
	textField.placeholder = [delegate textPlaceholder];
	textField.text = [delegate textValue];
	
	// show keyboard
	[textField becomeFirstResponder];

}


/*
* Cleans up the view.
*/
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	FLog();

	// dismiss
	[textField resignFirstResponder];
	
	// delegate
	if (delegate != nil && [delegate respondsToSelector:@selector(updateText:)]) {
        NSString *text = [textField text];
        if ([text isEqualToString:@""]) {
            text = NULL;
        }
		[delegate updateText:text];
	}
}




#pragma mark -
#pragma mark UITextFieldDelegate


/*
* Text Field should return.
*/
- (BOOL)textFieldShouldReturn:(UITextField *)_textField {

	// dismiss the keyboard
	[_textField resignFirstResponder];
	
	// and pop it goes
	[self.navigationController popViewControllerAnimated:YES];

	// back to business
	return YES;
}



#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
	[textField release];
    [super dealloc];
}



@end
