//
//  CellColor.h
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

#import <Foundation/Foundation.h>
#import "CellInput.h"
#import "CellColorViewController.h"



/**
 * ColorSwatch.
 */
@interface ColorSwatch : NSObject {
    
}

// Properties
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) UIColor * color;

// Object Methods
- (id)initWithLabel:(NSString*)l color:(UIColor*)c;

@end


/**
 * CellColorDelegate Protocol.
 */
@class CellColor;
@protocol CellColorDelegate <NSObject>
- (void)cellColorChanged:(CellColor*)c;
- (void)cellColorApply:(CellColor*)c;
@end


/**
 * CellColor.
 */
@interface CellColor : CellInput <CellColorViewDelegate> {
    
    // delegate
	id<CellColorDelegate>delegate;
    
	// data
	NSString *label;
    float color_r;
    float color_g;
    float color_b;
    
    // swatches
    NSArray *swatches;
    
}

// Properties
@property (assign) id<CellColorDelegate> delegate;
@property (nonatomic, retain) NSString *label;
@property float color_r;
@property float color_g;
@property float color_b;
@property (nonatomic, retain) NSArray *swatches;

// Business Methods
- (CellColorViewController*)colorViewController:(CGRect)cframe;

@end
