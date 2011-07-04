//
//  CellPicker.h
//  P5P
//
//  Created by CNPP on 3.3.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CellInput.h"
#import "CellPickerViewController.h"



/**
 * PickerData.
 */
@interface PickerData : NSObject {

}

// Properties
@property NSInteger index;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSString * value;

// Object Methods
- (id)initWithIndex:(NSInteger)i label:(NSString*)l value:(NSString*)v;

@end


/**
 * CellPickerDelegate Protocol.
 */
@class CellPicker;
@protocol CellPickerDelegate <NSObject>
	- (void)cellPickerChanged:(CellPicker*)c;
@end

/**
* CellPicker.
*/
@interface CellPicker : CellInput <CellPickerViewDelegate> {

	// delegate
	id<CellPickerDelegate>delegate;

	// data
	NSMutableArray *values;
	NSString *label;
	NSString *plabel;
	NSString *pvalue;
	NSInteger pindex;
	
}

// Properties
@property (assign) id<CellPickerDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *values;
@property (nonatomic, retain) NSString *label;
@property (nonatomic, retain) NSString *plabel;
@property (nonatomic, retain) NSString *pvalue;
@property NSInteger pindex;

// Business Methods
- (CellPickerViewController*)pickerViewController:(CGRect)pframe;

@end
