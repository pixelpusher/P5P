//
//  SketchViewController_iPad.m
//  P5P
//
//  Created by CNPP on 23.1.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

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
	[[[sPopoverController contentViewController] view] setAlpha:0.9f];
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
