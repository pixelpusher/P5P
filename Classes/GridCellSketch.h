//
//  GridCellSketch.h
//  P5P
//
//  Created by CNPP on 17.2.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridViewCell.h"


/**
* GridCellSketch.
*/
@interface GridCellSketch : AQGridViewCell {

	// label
	UIImageView *sketchImage;
	UILabel *sketchTitle;
	UILabel *sketchMeta;
}

// Properties
@property (nonatomic, retain) UIImageView *sketchImage;
@property (nonatomic, retain) UILabel *sketchTitle;
@property (nonatomic, retain) UILabel *sketchMeta;

@end
