//
//  GridCellCollection.m
//  P5P
//
//  Created by CNPP on 24.2.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "GridCellCollection.h"
#import <QuartzCore/QuartzCore.h>
#import "P5PAppDelegate.h"


/**
* GridCellCollection.
*/
@implementation GridCellCollection

#pragma mark -
#pragma mark Properties

// accessors
@synthesize collectionImage;
@synthesize collectionTitle;
@synthesize disabled;


#pragma mark -
#pragma mark GridCell Methods


/**
 * Init cell.
 */
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {

	// init self
    self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier];
    if (self != nil) {
	
		// sketch image
		float imgWidth = 72;
		float imgHeight = 72;
		float imgX = (frame.size.width-imgWidth)/2.0;
		float imgY = 15;
		UIImageView *imgCollectionImage = [[UIImageView alloc] initWithFrame:CGRectMake(imgX, imgY, imgWidth, imgHeight)];
		imgCollectionImage.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		imgCollectionImage.backgroundColor = [UIColor whiteColor];
		imgCollectionImage.contentMode = UIViewContentModeScaleAspectFit;
		imgCollectionImage.opaque = YES;
		imgCollectionImage.layer.masksToBounds = YES;
		imgCollectionImage.layer.cornerRadius = 10;
		
		UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, imgWidth, imgHeight) cornerRadius:10];
		imgCollectionImage.clipsToBounds = NO;
		imgCollectionImage.layer.shadowPath = path.CGPath;
		imgCollectionImage.layer.shadowColor = [UIColor blackColor].CGColor;
		imgCollectionImage.layer.shadowRadius = 3.0;
		imgCollectionImage.layer.shadowOpacity = 0.2;
		imgCollectionImage.layer.shadowOffset = CGSizeMake(2,2);
		self.collectionImage = imgCollectionImage;
		[self.contentView addSubview: collectionImage];
		[imgCollectionImage release];
		
		// labels
		float lblWidth = frame.size.width;
		float lblHeight = 25;
		
		
		// sketch title
		UILabel *lblCollectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0, imgY+imgHeight, lblWidth, lblHeight)];
		lblCollectionTitle.backgroundColor = [UIColor clearColor];
		lblCollectionTitle.font = [UIFont fontWithName:@"Helvetica" size:15.0];
		lblCollectionTitle.textColor = [UIColor whiteColor];
		if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
			lblCollectionTitle.font = [UIFont fontWithName:@"Helvetica" size:14.0];
		} 
		lblCollectionTitle.textAlignment = UITextAlignmentCenter;
		lblCollectionTitle.opaque = YES;
		lblCollectionTitle.text = @"Collection";
		self.collectionTitle = lblCollectionTitle;
		[self.contentView addSubview: collectionTitle];
		[lblCollectionTitle release];
		
	
    
		// cell
		self.contentView.backgroundColor = [UIColor clearColor];
		self.backgroundColor = [UIColor clearColor];
		self.contentView.opaque = YES;
		self.opaque = YES;
		self.selectionStyle = AQGridViewCellSelectionStyleNone;
	
	}

    
	// return
    return self ;
}


/**
* Highlighted.
*/
- (void) setHighlighted:(BOOL)value {
	[self setHighlighted: value animated: NO];
}
- (void) setHighlighted:(BOOL)value animated:(BOOL)animated {
	GLog(@"%@",value ? @"yes":@"no");
	if (value) {
		self.contentView.frame = CGRectOffset(self.contentView.frame, 1, 1);
		collectionImage.layer.shadowColor = [UIColor clearColor].CGColor;
	}
	else {
		self.contentView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
		collectionImage.layer.shadowColor = [UIColor blackColor].CGColor;
	}

}

/**
* Selected.
*/
- (void)setSelected:(BOOL)value {
	[self setSelected: value animated: NO];
}
- (void)setSelected:(BOOL)value animated:(BOOL)animated {
	GLog(@"%@",value ? @"yes":@"no");
	[super setSelected:value animated:animated];
	
	// reset highlight
	self.contentView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
	collectionImage.layer.shadowColor = [UIColor blackColor].CGColor;
}


/**
* Disabled.
*/
- (void)setDisabled:(BOOL)value {
	GLog();
	
	// field
	disabled = value;
	
	// ui
	if (disabled) {
		collectionImage.alpha = 0.3;
	}
	else {
		collectionImage.alpha = 1.0;
	}

}

/*
* Touch.
*/
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	[(P5PAppDelegate*)[[UIApplication sharedApplication] delegate] playSampleSelected];
}



#pragma mark -
#pragma mark Business Methods


/*
* Rounded image.
*/
- (void)collectionImageRounded:(UIImage *)img {
	GLog();
	collectionImage.image = img;
	collectionImage.layer.masksToBounds = YES;
	collectionImage.layer.cornerRadius = 10;
}





#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void) dealloc {
    [collectionImage release];
	[collectionTitle release];
    [super dealloc];
}



@end
