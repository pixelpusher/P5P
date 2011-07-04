//
//  CellColorViewController.h
//  P5P
//
//  Created by CNPP on 1.7.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMColorPicker.h"


// Structures
struct hsv_color {
    float hue;
    float sat;
    float val;
};
struct rgb_color {
    float r;
    float g;
    float b;
};



/**
 * CellColorDelegate Protocol.
 */
@class CellColor;
@protocol CellColorViewDelegate <NSObject>
- (NSString*)controllerTitle;
- (void)selectColor:(UIColor*)c;
- (void)clearColor;
- (void)applyColor;
@end


/**
 * CellColorViewController.
 */
@interface CellColorViewController : UIViewController {
    
    // ui
    UIView *viewSelection;
    UILabel *labelSelectionRGB;
    UILabel *labelSelectionHSV;
    CMColorPicker *colorPicker;
    
    // data
    NSMutableArray *swatches;
    
}

// Properties
@property (assign) id<CellColorViewDelegate> delegate;
@property (nonatomic, assign) NSMutableArray *swatches;
@property (nonatomic, assign) CMColorPicker *colorPicker;

// Object Methods
- (id)initWithFrame:(CGRect)frame swatches:(NSArray*)colorSwatches;

// Business Methods
- (void)initialColor:(UIColor*)c;

// Actions
- (void)actionSwatch:(id)sender;
- (void)actionColor:(id)sender;
- (void)actionClear:(id)sender;
- (void)actionSetColor:(id)sender;
- (void)actionApply:(id)sender;

@end
