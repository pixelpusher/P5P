//
//  GridCellSketch.m
//  P5P
//
//  Created by CNPP on 17.2.2011.
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

#import "GridCellSketch.h"
#import <QuartzCore/QuartzCore.h>
#import "P5PAppDelegate.h"


/**
* GridCellSketch.
*/
@implementation GridCellSketch


#pragma mark -
#pragma mark Properties

// accessors
@synthesize sketchImage;
@synthesize sketchTitle;
@synthesize sketchMeta;


#pragma mark -
#pragma mark GridCell Methods


/*
 * Init cell.
 */
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {

	// init self
    self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier];
    if (self != nil) {
	
		// sketch image
		float imgWidth = frame.size.width;
		float imgHeight = frame.size.width * (8.0/6.0);
		UIImageView *imgSketchImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgWidth, imgHeight)];
		imgSketchImage.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		imgSketchImage.backgroundColor = [UIColor whiteColor];
		imgSketchImage.contentMode = UIViewContentModeScaleAspectFit;
		
		UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0.0, 0.0, imgWidth, imgHeight)];
		imgSketchImage.clipsToBounds = NO;
		imgSketchImage.layer.shadowPath = path.CGPath;
		imgSketchImage.layer.shadowColor = [UIColor blackColor].CGColor;
		imgSketchImage.layer.shadowRadius = 3.0;
		imgSketchImage.layer.shadowOpacity = 0.2;
		imgSketchImage.layer.shadowOffset = CGSizeMake(2,2);
		self.sketchImage = imgSketchImage;
		[self.contentView addSubview: sketchImage];
		[imgSketchImage release];
		
		// labels
		float lblWidth = frame.size.width;
		float lblHeight = 30;
		
		// sketch meta
		UILabel *lblSketchMeta = [[UILabel alloc] initWithFrame:CGRectMake(0.0, imgHeight, lblWidth, lblHeight)];
		lblSketchMeta.backgroundColor = [UIColor clearColor];
		lblSketchMeta.font = [UIFont fontWithName:@"Helvetica" size:12.0]; 
		lblSketchMeta.textColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:1.0];
		lblSketchMeta.shadowColor = [UIColor whiteColor];
		lblSketchMeta.shadowOffset = CGSizeMake(1,1);
		lblSketchMeta.textAlignment = UITextAlignmentRight;
		lblSketchMeta.opaque = YES;
		lblSketchMeta.text = @"meta";
		self.sketchMeta = lblSketchMeta;
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			[self.contentView addSubview: sketchMeta];
		}
		[lblSketchMeta release];
		
		// sketch title
		UILabel *lblSketchTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0, imgHeight, lblWidth, lblHeight)];
		lblSketchTitle.backgroundColor = [UIColor clearColor];
		lblSketchTitle.font = [UIFont fontWithName:@"Helvetica" size:15.0];
		lblSketchTitle.textColor = [UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0];
		lblSketchTitle.shadowColor = [UIColor whiteColor];
		lblSketchTitle.shadowOffset = CGSizeMake(1,1);
		lblSketchTitle.opaque = YES;
		if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
			lblSketchTitle.font = [UIFont fontWithName:@"Helvetica" size:14.0];
		} 
		lblSketchTitle.text = @"Sketch";
		self.sketchTitle = lblSketchTitle;
		[self.contentView addSubview: sketchTitle];
		[lblSketchTitle release];
		
	
    
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


/*
* Highlighted.
*/
- (void) setHighlighted:(BOOL)value {
	[self setHighlighted: value animated: NO];
}
- (void) setHighlighted:(BOOL)value animated:(BOOL)animated {
	GLog(@"%@",value ? @"yes":@"no");
	if (value) {
		self.contentView.frame = CGRectOffset(self.contentView.frame, 1, 1);
		sketchImage.layer.shadowColor = [UIColor clearColor].CGColor;
		sketchTitle.shadowColor = [UIColor clearColor];
		sketchMeta.shadowColor = [UIColor clearColor];
	}
	else {
		self.contentView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
		sketchImage.layer.shadowColor = [UIColor blackColor].CGColor;
		sketchTitle.shadowColor = [UIColor whiteColor];
		sketchMeta.shadowColor = [UIColor whiteColor];
	}

}

/*
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
	sketchImage.layer.shadowColor = [UIColor blackColor].CGColor;
	sketchTitle.shadowColor = [UIColor whiteColor];
	sketchMeta.shadowColor = [UIColor whiteColor];
}

/*
* Touch.
*/
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	[(P5PAppDelegate*)[[UIApplication sharedApplication] delegate] playSampleSelected];
}




#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void) dealloc {
    [sketchTitle release];
	[sketchMeta release];
	[sketchImage release];
    [super dealloc];
}



@end
