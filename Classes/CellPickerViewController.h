//
//  CellPickerViewController.h
//  P5P
//
//  Created by CNPP on 3.3.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * CellPickerDelegate Protocol.
 */
@class CellPicker;
@protocol CellPickerViewDelegate <NSObject>
	- (NSString*)controllerTitle;
	- (NSInteger)pickerIndex;
	- (NSMutableArray*)pickerValues;
	- (NSString*)pickerLabel:(NSInteger)index;
	- (NSString*)pickerLabel;
	- (void)pickedIndex:(NSInteger)index;
@end


/**
* CellPickerViewController.
*/
@interface CellPickerViewController : UIViewController  <UIPickerViewDataSource, UIPickerViewDelegate> {

	// ui
	UIPickerView *picker;
	UITextField *textField;

}

// Properties
@property (assign) id<CellPickerViewDelegate> delegate;
@property (nonatomic, assign) UIPickerView *picker;

// Object Methods
- (id)initWithFrame:(CGRect)frame;

// Actions
- (void)actionBack:(id)sender;

@end
