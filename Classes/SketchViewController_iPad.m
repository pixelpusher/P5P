//
//  SketchViewController_iPad.m
//  P5P
//
//  Created by CNPP on 23.1.2011.
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

#import "SketchViewController_iPad.h"
#import "SketchesViewController_iPad.h"



/**
* SketchViewController_iPad.
*/
@implementation SketchViewController_iPad



#pragma mark -
#pragma mark View lifecycle


/*
* Prepares the view.
*/
- (void)loadView {
	[super loadView];
	FLog();
	
	// settings popover
	UINavigationController *sNavigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
	UIPopoverController *sPopoverController = [[UIPopoverController alloc] initWithContentViewController:sNavigationController];
	[sPopoverController setPopoverContentSize:CGSizeMake(settingsViewController.view.frame.size.width, settingsViewController.view.frame.size.height)];
    sPopoverController.contentViewController.view.alpha = 0.9f;
	settingsPopoverController = [sPopoverController retain];
	[sPopoverController release];

}

/*
 * Prepares the view.
 */
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	DLog();
	
	// exclude modal
	if (! modeModal) {
        [settingsViewController reloadSettings];
    }
}

/*
* Resets the view.
*/
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	FLog();
	
	// dismiss settings popover
	if ([settingsPopoverController isPopoverVisible]) {
		[settingsPopoverController dismissPopoverAnimated:YES];
	} 
	
}


#pragma mark -
#pragma mark Actions


/*
* Settings.
*/
- (void)actionSettings:(id)sender {
	[super actionSettings:sender];
	DLog();

	// dismiss
	if ([settingsPopoverController isPopoverVisible]) {
		[settingsPopoverController dismissPopoverAnimated:YES];
	} 
	
	// show girl
	else {
        [settingsPopoverController.contentViewController.navigationController popToRootViewControllerAnimated:NO]; 
		[settingsPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}

}

/*
* Export.
*/
- (void)actionExport:(id)sender {
	[super actionExport:sender];
	DLog();

	// dismiss settings popover
	if ([settingsPopoverController isPopoverVisible]) {
		[settingsPopoverController dismissPopoverAnimated:NO];
	}
}




#pragma mark -
#pragma mark Memory management



/**
* Deallocates all used memory.
*/
- (void)dealloc {
	GLog();

	// self
	[settingsPopoverController release];
	
	// duper
    [super dealloc];
}


@end
