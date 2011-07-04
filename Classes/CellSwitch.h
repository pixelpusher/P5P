//
//  CellSwitch.h
//  P5P
//
//  Created by CNPP on 11.2.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CellInput.h"


/**
 * CellSwitchDelegate Protocol.
 */
@class CellSwitch;
@protocol CellSwitchDelegate <NSObject>
	- (void)cellSwitchChanged:(CellSwitch*)c;
@end


/**
 * Cell Switch.
 */
@interface CellSwitch : CellInput {

	// delegate
	id<CellSwitchDelegate>delegate;
	
	// ui
	UISwitch *switchAccessory;

}

// Properties
@property (assign) id<CellSwitchDelegate> delegate;
@property (nonatomic, retain) UISwitch *switchAccessory;



@end
