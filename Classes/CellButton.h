//
//  CellButton.h
//  P5P
//
//  Created by CNPP on 4.3.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CellInput.h"


/**
 * CellButtonDelegate Protocol.
 */
@class CellButton;
@protocol CellButtonDelegate <NSObject>
	- (void)cellButtonTouched:(CellButton*)c;
@end


/**
 * CellButton.
 */
@interface CellButton : CellInput {

	// delegate
	id<CellButtonDelegate>delegate;
	
	// ui
	UIButton *buttonAccessory;

}

// Properties
@property (assign) id<CellButtonDelegate> delegate;
@property (nonatomic, retain) UIButton *buttonAccessory;



@end
