//
//  GridCellCollection.h
//  P5P
//
//  Created by CNPP on 24.2.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridViewCell.h"


@interface GridCellCollection : AQGridViewCell {

	// label
	UIImageView *collectionImage;
	UILabel *collectionTitle;
	
	// fields
	BOOL disabled;
}

// Properties
@property (nonatomic, retain) UIImageView *collectionImage;
@property (nonatomic, retain) UILabel *collectionTitle;
@property BOOL disabled;

// Methods
- (void)collectionImageRounded:(UIImage*)img;


@end
