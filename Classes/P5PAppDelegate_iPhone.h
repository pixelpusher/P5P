//
//  P5PAppDelegate_iPhone.h
//  P5P
//
//  Created by CNPP on 27.1.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P5PAppDelegate.h"



/**
 * App Delegate iPhone.
 */
@interface P5PAppDelegate_iPhone : P5PAppDelegate {

	// ui
	UINavigationController *navigationController;
	
}

// Properties
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end
