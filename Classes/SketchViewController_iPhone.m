//
//  SketchViewController_iPhone.m
//  P5P
//
//  Created by CNPP on 27.1.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "SketchViewController_iPhone.h"


/**
* SketchViewController_iPhone.
*/
@implementation SketchViewController_iPhone


#pragma mark -
#pragma mark Actions

/*
* Settings.
*/
- (void)actionSettings:(id)sender {
	DLog();
	
	// enter modal moda
	//[self setModeModal:YES]; // in case view is hidden
 
	// navigation controller
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
	navController.navigationBar.barStyle = UIBarStyleBlack;
	navController.toolbar.barStyle = UIBarStyleBlack;
	navController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_settings.png"]];
	[navController setToolbarHidden:NO animated:NO];

 
	// show the navigation controller modally
	[navController setModalTransitionStyle:UIViewAnimationTransitionCurlUp];
	[self presentModalViewController:navController animated:YES];
 
	// Clean up resources
	[navController release];	
	
	// everything super
	[super actionSettings:sender];
}



#pragma mark -
#pragma mark SettingDelegate

/*
 * Settings apply.
 */
- (void)settingsApply {
	FLog();
	
	// pop it goes
	[self dismissModalViewControllerAnimated:YES];
	
	// leave modal mode
	//[self setModeModal:NO]; // in case view is hidden
	
	// refresh super
	[super settingsApply];
	
}


@end
