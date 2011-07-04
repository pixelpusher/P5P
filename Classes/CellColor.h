//
//  CellColor.h
//  P5P
//
//  Created by CNPP on 1.7.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

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
