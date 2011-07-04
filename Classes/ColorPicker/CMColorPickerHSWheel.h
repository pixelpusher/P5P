//
//  CMColorPickerWheel.h
//  colorPickerTest
//
//  Created by Alex Restrepo on 4/25/10.
//  Copyright 2010 Colombiamug/KZLabs. All rights reserved.
//
//  This code is released under the creative commons attribution-share alike licence, meaning:
//
//	Attribution - You must attribute the work in the manner specified by the author or licensor 
//	(but not in any way that suggests that they endorse you or your use of the work).
//	In this case, simple credit somewhere in your app or documentation will suffice.
//
//	Share Alike - If you alter, transform, or build upon this work, you may distribute the resulting
//	work only under the same, similar or a compatible license.
//	Simply put, if you improve upon it, share!
//
//	http://creativecommons.org/licenses/by-sa/3.0/us/
//

#import <UIKit/UIKit.h>
#import "HSV.h"

@interface CMColorPickerHSWheel : UIControl
{
	UIImageView *wheelImageView;	// background view
	UIImageView *wheelKnobView;		// knob
	
	HSVType currentHSV;	// current hsv value
}

@property (nonatomic) HSVType currentHSV;

- (id)initAtOrigin:(CGPoint)origin;
@end
