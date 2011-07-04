//
//  CellText.h
//  P5P
//
//  Created by CNPP on 6.3.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CellInput.h"
#import "CellTextViewController.h"


/**
 * CellTextDelegate Protocol.
 */
@class CellText;
@protocol CellTextDelegate <NSObject>
	- (void)cellTextChanged:(CellText*)c;
@end


/**
* CellText.
*/
@interface CellText : CellInput <CellTextViewDelegate> {

	// delegate
	id<CellTextDelegate>delegate;
	
	// controller
	CellTextViewController *cellTextViewController;

	// data
	NSString *label;
	NSString *text;
	NSString *placeholder;

	
}

// Properties
@property (assign) id<CellTextDelegate> delegate;
@property (nonatomic, retain) NSString *label;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *placeholder;

// Business Methods
- (CellTextViewController*)textViewController:(CGRect)pframe;

@end
