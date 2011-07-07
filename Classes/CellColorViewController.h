//
//  CellColorViewController.h
//  P5P
//
//  Created by CNPP on 1.7.2011.
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
