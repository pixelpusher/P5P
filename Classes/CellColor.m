//
//  CellColor.m
//  P5P
//
//  Created by CNPP on 1.7.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "CellColor.h"


/**
 * CellColor.
 */
@implementation CellColor

#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;
@synthesize label;
@synthesize color_r,color_g,color_b;
@synthesize swatches;


#pragma mark -
#pragma mark TableCell Methods

/*
 * Init cell.
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
	GLog();
	
	// init cell
    self = [super initWithStyle:style reuseIdentifier:identifier];
    if (self == nil) { 
        return nil;
    }
    
    // fields
    color_r = -1;
    color_g = -1;
    color_b = -1;
    
    
	// accessory
	self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    // show yourself
    return self;
}



#pragma mark -
#pragma mark Business Methods

/**
 * Creates a CellColorViewController.
 */
- (CellColorViewController*)colorViewController:(CGRect)pframe {
	FLog();
	
	// controller
	CellColorViewController *colorController = [[CellColorViewController alloc] initWithFrame:pframe swatches:swatches];
	colorController.delegate = self;
    if (color_r >= 0 && color_g >= 0 && color_b >= 0) {
        [colorController initialColor: [UIColor colorWithRed:color_r green:color_g blue:color_b alpha:1.0]];
    }
	return colorController;
	
}

#pragma mark -
#pragma mark Business

/**
 * Updates the cell.
 */
- (void)update:(BOOL)reset {
	GLog();
    
    // number formater
	static NSNumberFormatter *numberFormatter = nil;
	if (numberFormatter == nil) {
		numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
		[numberFormatter setMaximumFractionDigits:0];
        [numberFormatter setMinimumIntegerDigits:3];
		[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	}
	
    // color
    if (color_r < 0 || color_g < 0 || color_b < 0) {
        self.detailTextLabel.text = NSLocalizedString(@"Random", @"Random");
    }
    else {
        self.detailTextLabel.text = [NSString stringWithFormat:@"R: %@, G: %@, B: %@",
                                     [numberFormatter stringFromNumber:[NSNumber numberWithFloat:color_r*255]],
                                     [numberFormatter stringFromNumber:[NSNumber numberWithFloat:color_g*255]],
                                     [numberFormatter stringFromNumber:[NSNumber numberWithFloat:color_b*255]]];
    }
    
}


#pragma mark -
#pragma mark CellColorViewDelegate


/*
 * Returns the title.
 */
- (NSString*)controllerTitle {
	DLog();
	return label;
}


/*
 * Selected color.
 */
- (void)selectColor:(UIColor *)c {
	DLog();
	
    
    // set
	const CGFloat *cgc = CGColorGetComponents(c.CGColor);  
    color_r = cgc[0];
    color_g = cgc[1];
    color_b = cgc[2];
	
	
	// delegate
	if (delegate != nil && [delegate respondsToSelector:@selector(cellColorChanged:)]) {
		[delegate cellColorChanged:self];
	}
    
}

/*
 * Clear color.
 */
- (void)clearColor {
	DLog();
	    
    // set
    color_r = -1;
    color_g = -1;
    color_b = -1;
	
	// delegate
	if (delegate != nil && [delegate respondsToSelector:@selector(cellColorChanged:)]) {
		[delegate cellColorChanged:self];
	}
    
}

/*
 * Apply color.
 */
- (void)applyColor {
	DLog();
	
	// delegate
	if (delegate != nil && [delegate respondsToSelector:@selector(cellColorApply:)]) {
		[delegate cellColorApply:self];
	}
    
}





#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
    [super dealloc];
}


@end



/**
 * ColorSwatch.
 */
@implementation ColorSwatch

#pragma mark -
#pragma mark Properties

// accessors
@synthesize label;
@synthesize color;


#pragma mark -
#pragma mark Object Methods

/**
 * Init.
 */
- (id)initWithLabel:(NSString *)l color:(UIColor *)c {
	GLog();
	if ((self = [super init])) {
		self.label = l;
		self.color = c;
	}
	return self;
}



#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
	
	// self
	[label release];
	[color release];
	
	// super
    [super dealloc];
}

@end

