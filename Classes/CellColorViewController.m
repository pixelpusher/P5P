//
//  CellColorViewController.m
//  P5P
//
//  Created by CNPP on 1.7.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CellColorViewController.h"
#import "CellColor.h"


/*
 * Helper Stack.
 */
@interface CellColorViewController (Helpers)
- (void)updateColor:(UIColor*)c;
- (void)updateSelection:(UIColor*)c;
- (struct hsv_color)rgb2hsv:(struct rgb_color)rgb;
@end


/**
 * CellColorViewController.
 */
@implementation CellColorViewController


#pragma mark -
#pragma mark Properties

// accessors 
@synthesize delegate;
@synthesize swatches;
@synthesize colorPicker;


#pragma mark -
#pragma mark Object Methods

/**
 * Init with frame.
 */
- (id)initWithFrame:(CGRect)frame swatches:(NSArray *)colorSwatches {
    DLog();
    
    // init
	if ((self = [super init])) {
        
		// view
		self.view = [[UIView alloc] initWithFrame:frame];
		self.contentSizeForViewInPopover = CGSizeMake(frame.size.width, frame.size.height);
		self.view.backgroundColor = [UIColor colorWithRed:219.0/255.0 green:222.0/255.0 blue:227.0/255.0 alpha:1.0];
		
		// remove background for iphone
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
			self.view.backgroundColor = [UIColor clearColor];
			self.view.opaque = YES;
		}
        
        // values
        float inset = 20;
        
        
        // selection view
        UIView *sv = [[UIView alloc] initWithFrame:CGRectMake(inset, 15, (frame.size.width/2.0)-inset, 60)];
        sv.backgroundColor = [UIColor whiteColor];
        sv.layer.borderColor = [UIColor whiteColor].CGColor;
        sv.layer.cornerRadius = 3.0;
        sv.layer.borderWidth = 2.0;
        
        viewSelection = [sv retain];
        [self.view addSubview:viewSelection];
        [sv release];
        
        
        // selection label rgb
        UILabel *lblSelectionRGB = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width/2.0)+inset, 15, 50, 60)];
        lblSelectionRGB.backgroundColor = [UIColor clearColor];
        lblSelectionRGB.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        lblSelectionRGB.textColor = [UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0];
        lblSelectionRGB.shadowColor = [UIColor whiteColor];
        lblSelectionRGB.shadowOffset = CGSizeMake(1,1);
        lblSelectionRGB.opaque = YES;
        lblSelectionRGB.numberOfLines = 3;
        
        labelSelectionRGB = [lblSelectionRGB retain];
        [labelSelectionRGB setText:[NSString stringWithFormat:@"R: \nG: \nB:"]];
        [self.view addSubview:labelSelectionRGB];
        [lblSelectionRGB release];
        
        // selection label hsv
        UILabel *lblSelectionHSV = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width/2.0)+inset+45+inset, 15, 50, 60)];
        lblSelectionHSV.backgroundColor = [UIColor clearColor];
        lblSelectionHSV.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        lblSelectionHSV.textColor = [UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0];
        lblSelectionHSV.shadowColor = [UIColor whiteColor];
        lblSelectionHSV.shadowOffset = CGSizeMake(1,1);
        lblSelectionHSV.opaque = YES;
        lblSelectionHSV.numberOfLines = 3;
        
        labelSelectionHSV = [lblSelectionHSV retain];
        [labelSelectionHSV setText:[NSString stringWithFormat:@"H: \nS: \nV:"]];
        [self.view addSubview:labelSelectionHSV];
        [lblSelectionHSV release];
        
        
        // color picker
        CMColorPicker *cp = [[CMColorPicker alloc] initAtOrigin:CGPointMake(5, 75)];
        [cp addTarget:self action:@selector(actionColor:) forControlEvents:UIControlEventValueChanged];	
        
        colorPicker = [cp retain];
        [self.view addSubview:colorPicker];
        [cp release];
        
        
        // custom swatches
        swatches = [[NSMutableArray alloc] init];
        if (colorSwatches) {
            for (ColorSwatch *s in colorSwatches) {
                [swatches addObject:s];
            }
        }
        // default
        else {
            
            // Japanese Palette
            [swatches addObject:[[ColorSwatch alloc] initWithLabel:@"Shikan-cha" color:[UIColor colorWithRed:181.0/255.0 green:163.0/255.0 blue:131.0/255.0 alpha:1.0]]];
            [swatches addObject:[[ColorSwatch alloc] initWithLabel:@"Kimidori" color:[UIColor colorWithRed:187.0/255.0 green:192.0/255.0 blue:0/255.0 alpha:1.0]]];
            [swatches addObject:[[ColorSwatch alloc] initWithLabel:@"Uguisu-cha" color:[UIColor colorWithRed:123.0/255.0 green:137.0/255.0 blue:66.0/255.0 alpha:1.0]]];
            [swatches addObject:[[ColorSwatch alloc] initWithLabel:@"Sabiasagi" color:[UIColor colorWithRed:105.0/255.0 green:153.0/255.0 blue:174.0/255.0 alpha:1.0]]];
            //[swatches addObject:[[ColorSwatch alloc] initWithLabel:@"Syobu-iro" color:[UIColor colorWithRed:141.0/255.0 green:0.0/255.0 blue:203.0/255.0 alpha:1.0]]];
            [swatches addObject:[[ColorSwatch alloc] initWithLabel:@"Botan-iro" color:[UIColor colorWithRed:225.0/255.0 green:0.0/255.0 blue:178.0/255.0 alpha:1.0]]];
            [swatches addObject:[[ColorSwatch alloc] initWithLabel:@"Shinkou" color:[UIColor colorWithRed:229.0/255.0 green:0.0/255.0 blue:30.0/255.0 alpha:1.0]]];

        }
        
        
        // swatches
        float sb = 10;
        float sw = (frame.size.width-2*inset-2*sb) / 3.0;
        float sh = 30;
        float sy = 310;
        float sx = 0;
        for (int i = 0; i < [swatches count]; i++) {
            
            // position
            sx = inset + (i % 3) * (sw+sb);
            
            // swatch
            ColorSwatch *swatch = [swatches objectAtIndex:i];
            
            // button
            UIButton *btnSwatch = [UIButton buttonWithType:UIButtonTypeCustom];
            btnSwatch.frame = CGRectMake(sx,sy,sw,sh);
            btnSwatch.backgroundColor = swatch.color;
            btnSwatch.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
            btnSwatch.layer.borderColor = [UIColor whiteColor].CGColor;
            btnSwatch.layer.cornerRadius = 3.0;
            btnSwatch.layer.borderWidth = 2.0;
            
            [btnSwatch setTitle:swatch.label forState:UIControlStateNormal];
            [btnSwatch addTarget:self action:@selector(actionSwatch:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btnSwatch];
            
            // increment
            if (i % 3 == 2 && i < [swatches count] - 1) {
                sy += sh + sb;
            }
        }
        
        // increment
        sy += sh + sb;
        
        
        // clear
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            // button apply
            UIBarButtonItem *btnApply = [[UIBarButtonItem alloc] 
                                         initWithTitle:NSLocalizedString(@"Apply",@"Apply")
                                         style:UIBarButtonItemStyleBordered 
                                         target:self 
                                         action:@selector(actionApply:)];
            
            
            // navigation
            self.navigationItem.rightBarButtonItem = btnApply;
            [btnApply release];	
            
            
            // button
			UIButton *btnClear = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btnClear.frame = CGRectMake(inset, sy, self.view.frame.size.width-2*inset, 40); 
            btnClear.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0]; 
            [btnClear setTitleColor:[UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            
            [btnClear setTitle:NSLocalizedString(@"Clear Color",@"Clear Color") forState:UIControlStateNormal];
            [btnClear addTarget:self action:@selector(actionClear:) forControlEvents:UIControlEventTouchUpInside];
            
            // add
            [self.view addSubview:btnClear];
            
            
		}
        else {

            
            // button clear
            UIBarButtonItem *btnClear = [[UIBarButtonItem alloc] 
                                         initWithTitle:NSLocalizedString(@"Clear",@"Clear")
                                         style:UIBarButtonItemStyleBordered 
                                         target:self 
                                         action:@selector(actionClear:)];
            
            // button set
            UIBarButtonItem *btnSet = [[UIBarButtonItem alloc] 
                                         initWithTitle:NSLocalizedString(@"Set Color",@"Set Color")
                                         style:UIBarButtonItemStyleBordered 
                                         target:self 
                                         action:@selector(actionSetColor:)];
            
            
            // flex
            UIBarButtonItem *flex = [[UIBarButtonItem alloc] 
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                     target:nil 
                                     action:nil];
            
            // spacer
            UIBarButtonItem *spacer = [[UIBarButtonItem alloc] 
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace 
                                       target:self
                                       action:nil];
            spacer.width = 5;
            
            
            // toolbar
            self.toolbarItems = [NSArray arrayWithObjects:
                                 spacer,
                                 btnClear,
                                 flex,
                                 btnSet,
                                 spacer,
                                 nil];

        }

    }
        
    // return
    return self;
}



#pragma mark -
#pragma mark View lifecycle


/*
 * Prepares the view.
 */
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	DLog();
    
    // title
	self.title = [delegate controllerTitle];

}


#pragma mark -
#pragma mark Business


/*
 * Presets the color.
 */
- (void)initialColor:(UIColor *)c {
    FLog();
    
    // picker
    self.colorPicker.selectedColor = c;
    
    // update selection
    [self updateSelection:c];
}




#pragma mark -
#pragma mark Actions


/*
 * Action color.
 */
- (void) actionColor:(CMColorPicker *)picker {
    GLog();
    
    // update selection
    [self updateSelection:picker.selectedColor];
    
    // update color
    [self updateColor:picker.selectedColor];
}


/*
 * Action swatch.
 */
- (void)actionSwatch:(UIView *)swatch {
    FLog();
    
    // set picker
	[colorPicker setSelectedColor:swatch.backgroundColor animated:YES];
	
    // update selection
    [self updateSelection:colorPicker.selectedColor];
    
    // update color
    [self updateColor:colorPicker.selectedColor];
}

/*
 * Action clear.
 */
- (void)actionClear:(id)sender {
    FLog();
    
    // picker
    colorPicker.selectedColor = [UIColor whiteColor];
    
    // clear
	if (delegate != nil && [delegate respondsToSelector:@selector(clearColor)]) {
		[delegate clearColor];
	}
    
    // selection
	viewSelection.backgroundColor = [UIColor whiteColor];
    
    // label
    [labelSelectionRGB setText:[NSString stringWithFormat:@"R: \nG: \nB: "]];
    [labelSelectionHSV setText:[NSString stringWithFormat:@"H: \nS: \nV:"]];
}



/*
 * Action set.
 */
- (void)actionSetColor:(id)sender {
    FLog();
    
    // color already back, go back
    [self.navigationController popViewControllerAnimated:YES];
}


/*
 * Action apply.
 */
- (void)actionApply:(id)sender {
    FLog();
    
    // apply
	if (delegate != nil && [delegate respondsToSelector:@selector(applyColor)]) {
		[delegate applyColor];
	}
}





#pragma mark -
#pragma mark Helpers


/*
 * Updates the selection.
 */
- (void)updateSelection:(UIColor *)c {
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
    
    // selection
	viewSelection.backgroundColor = c;
    
    // color values
    const CGFloat *cgc = CGColorGetComponents(c.CGColor);  
    struct rgb_color rgb;
    rgb.r = cgc[0];
    rgb.g = cgc[1];
    rgb.b = cgc[2];
    struct hsv_color hsv = [self rgb2hsv:rgb];
    
    
    // label
    [labelSelectionRGB setText:[NSString stringWithFormat:@"R: %@ \nG: %@ \nB: %@",
                                [numberFormatter stringFromNumber:[NSNumber numberWithFloat:rgb.r*255]],
                                [numberFormatter stringFromNumber:[NSNumber numberWithFloat:rgb.g*255]],
                                [numberFormatter stringFromNumber:[NSNumber numberWithFloat:rgb.b*255]]]];
    
    [labelSelectionHSV setText:[NSString stringWithFormat:@"H: %@ \nS: %@ \nV: %@",
                                [numberFormatter stringFromNumber:[NSNumber numberWithFloat:hsv.hue]],
                                [numberFormatter stringFromNumber:[NSNumber numberWithFloat:hsv.sat*100]],
                                [numberFormatter stringFromNumber:[NSNumber numberWithFloat:hsv.val*100]]]];
    
}

/*
 * Updates the color.
 */
- (void)updateColor:(UIColor*)c {
    GLog();
    
    // delegate
	if (delegate != nil && [delegate respondsToSelector:@selector(selectColor:)]) {
		[delegate selectColor:c];
	}
}

/*
 * Converts rgb to hsv.
 * @url: http://craigcoded.com/2010/11/30/getting-hsv-from-uicolor/
 */
-(struct hsv_color)rgb2hsv:(struct rgb_color)rgb {
    struct hsv_color hsv;
    
    CGFloat rgb_min, rgb_max;
    rgb_min = MIN(MIN(rgb.r, rgb.g), rgb.b);
    rgb_max = MAX(MAX(rgb.r, rgb.g), rgb.b);
    
    // hue
    if (rgb_max == rgb_min) {
        hsv.hue = 0;
    } else if (rgb_max == rgb.r) {
        hsv.hue = 60.0f * ((rgb.g - rgb.b) / (rgb_max - rgb_min));
        hsv.hue = fmodf(hsv.hue, 360.0f);
    } else if (rgb_max == rgb.g) {
        hsv.hue = 60.0f * ((rgb.b - rgb.r) / (rgb_max - rgb_min)) + 120.0f;
    } else if (rgb_max == rgb.b) {
        hsv.hue = 60.0f * ((rgb.r - rgb.g) / (rgb_max - rgb_min)) + 240.0f;
    }
    
    // checks
    if (hsv.hue < 0) {
        hsv.hue = 360+hsv.hue;
    }
    
    
    // saturation
    if (rgb_max == 0) {
        hsv.sat = 0;
    } else {
        hsv.sat = 1.0 - (rgb_min / rgb_max);
    }
    
    // value
    hsv.val = rgb_max;
    
    return hsv;
}


#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
    
    // superduper
    [super dealloc];
}

@end