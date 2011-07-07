//
//  CellText.h
//  P5P
//
//  Created by CNPP on 6.3.2011.
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
