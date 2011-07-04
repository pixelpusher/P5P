//
//  CellRange.h
//  P5P
//
//  Created by CNPP on 3.3.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CellInput.h"
#import "DoubleSlider.h"


/**
 * CellRangeDelegate Protocol.
 */
@class CellRange;
@protocol CellRangeDelegate <NSObject>
	- (void)cellRangeChanged:(CellRange*)c;
@end


/**
 * CellRange.
 */
@interface CellRange : CellInput {

	// delegate
	id<CellRangeDelegate>delegate;
	
	// ui
	DoubleSlider *rangeAccessory;

}

// Properties
@property (assign) id<CellRangeDelegate> delegate;
@property (nonatomic, retain) DoubleSlider *rangeAccessory;


@end
