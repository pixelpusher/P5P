//
//  CellTextViewController.m
//  P5P
//
//  Created by CNPP on 6.3.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

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
		self.view.backgroundColor = [UIColor colorWithRed:219.0/255.0 green:222.0/255.0 blue:227.0/255.0 alpha:1.0];
		
		// remove background for iphone
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
			self.view.backgroundColor = [UIColor clearColor];
			self.view.opaque = YES;
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
		[delegate updateText:[textField text]];
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
