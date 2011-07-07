    //
//  CellPickerViewController.m
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

#import "CellPickerViewController.h"
#import <QuartzCore/QuartzCore.h>


/**
* CellPickerViewController.
*/
@implementation CellPickerViewController


#pragma mark -
#pragma mark Properties

// accessors 
@synthesize delegate;
@synthesize picker;



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
		
		// iphone
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            
            // remove background
			self.view.backgroundColor = [UIColor clearColor];
			self.view.opaque = YES;
            
            
            // button back
            UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] 
                                       initWithTitle:NSLocalizedString(@"← Back",@"← Back")
                                       style:UIBarButtonItemStyleBordered 
                                       target:self 
                                       action:@selector(actionBack:)];
            
            
            // flex
            UIBarButtonItem *flex = [[UIBarButtonItem alloc] 
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                     target:nil 
                                     action:nil];
            
            // spacer
            UIBarButtonItem *spacer = [[UIBarButtonItem alloc] 
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace 
                                       target:self
                                       action:nil];
            spacer.width = 5;
            
            
            // toolbar
            self.toolbarItems = [NSArray arrayWithObjects:
                                 spacer,
                                 btnBack,
                                 flex,
                                 nil];
		}
	

		
		// position the picker at the bottom
		UIPickerView *p = [[UIPickerView alloc] initWithFrame:CGRectZero];
	
		p.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
		CGSize pickerSize = [p sizeThatFits:CGSizeZero];
		CGRect pickerRect = CGRectMake(	0.0,
									self.view.frame.size.height - pickerSize.height,
									pickerSize.width,
									pickerSize.height);
		p.frame = pickerRect;
		p.showsSelectionIndicator = YES;	// note this is default to NO
	
		// data source and delegate
		p.delegate = self;
		p.dataSource = self;
	
		// add to view
		self.picker = p;
		[self.view addSubview:picker];
		[p release];
		
		// text field
		textField = [[UITextField alloc] initWithFrame:CGRectMake(10,20,self.view.frame.size.width-20,40)];
		textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		textField.backgroundColor = [UIColor whiteColor];
		textField.layer.cornerRadius = 10;
		
		// add to view
		[self.view addSubview:textField];
	}
	return self;
}



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
	textField.text = [NSString stringWithFormat:@"  %@",[delegate pickerLabel]];
	
	// picker
	[picker selectRow:[delegate pickerIndex] inComponent:0 animated:YES];
}



#pragma mark -
#pragma mark Actions

/*
 * Action back.
 */
- (void)actionBack:(id)sender {
    FLog();
    
    // go back
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UIPickerViewDataSource

/*
* Number of components.
*/
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	return 1;
}

/*
* Number of rows.
*/
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
	// delegate
	if (delegate != nil && [delegate respondsToSelector:@selector(pickerValues)]) {
		return [[delegate pickerValues] count];
	}
	return 0;
}

/*
* Titles.
*/
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	// delegate
	if (delegate != nil && [delegate respondsToSelector:@selector(pickerLabel:)]) {
		return [delegate pickerLabel:row];
	}
	return nil;
}


#pragma mark -
#pragma mark UIPickerViewDelegate


/*
* Selected picker.
*/
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	FLog();
	
	// delegate
	if (delegate != nil && [delegate respondsToSelector:@selector(pickedIndex:)]) {
		[delegate pickedIndex:row];
	}
	
	// set in picker
	textField.text = [NSString stringWithFormat:@"  %@",[delegate pickerLabel]];
}



#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
	[picker release];
	[textField release];
    [super dealloc];
}



@end
