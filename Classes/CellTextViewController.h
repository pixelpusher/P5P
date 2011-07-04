//
//  CellTextViewController.h
//  P5P
//
//  Created by CNPP on 6.3.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * CellTextDelegate Protocol.
 */
@class CellText;
@protocol CellTextViewDelegate <NSObject>
	- (NSString*)controllerTitle;
	- (NSString*)textValue;
	- (NSString*)textPlaceholder;
	- (void)updateText:(NSString*)txt;
@end


/**
* CellTextViewController.
*/
@interface CellTextViewController : UIViewController  <UITextFieldDelegate> {

	// delegate
	id<CellTextViewDelegate>delegate;

	// ui
	UITextField *textField;

}

// Properties
@property (assign) id<CellTextViewDelegate> delegate;
@property (nonatomic, assign) UITextField *textField;

// Object Methods
- (id)initWithFrame:(CGRect)frame;

@end