//
//  SketchesViewController.h
//  P5P
//
//  Created by CNPP on 28.1.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P5PViewController.h"
#import	"InfoViewController.h"
#import "AQGridView.h"
#import "ColorPageControl.h"



/**
* SketchesViewController.
*/
@interface SketchesViewController : UIViewController <UIScrollViewDelegate, AQGridViewDataSource, AQGridViewDelegate, InfoDelegate>  {

	// delegate
	id<P5PDelegate>delegate;
	
	
	// ui
	UIScrollView *scrollView;
	ColorPageControl *pageControl;
	UIButton *buttonInfo;
	UIButton *buttonCollections;

	// data
	NSMutableArray *sketches;
	NSMutableArray *grids;
	
	// fields
	int nbOfItemsPerPage;
	float gridCellWidth;
	float gridCellHeight;
	
	// private
	@private
	BOOL pageControlIsChangingPage;
	int nbOfItems;
	int nbOfPages;

}
// Properties
@property (assign) id<P5PDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *sketches;
@property (nonatomic, retain) UIView *scrollView;
@property (nonatomic, retain) ColorPageControl *pageControl;
@property (nonatomic, retain) UIButton *buttonInfo;
@property (nonatomic, retain) UIButton *buttonCollections;

// Business Methods
- (void)reloadSketches;

// Action Methods
- (void)actionInfo:(id)sender;
- (void)actionCollections:(id)sender;


@end
