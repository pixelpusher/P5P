//
//  CollectionsViewController.h
//  P5P
//
//  Created by CNPP on 24.2.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P5PViewController.h"
#import "AQGridView.h"
#import "ColorPageControl.h"


/**
* CollectionsViewController.
*/
@interface CollectionsViewController : UIViewController <UIScrollViewDelegate, AQGridViewDataSource, AQGridViewDelegate>  {

	// delegate
	id<P5PDelegate>delegate;
	
	// ui
	UIScrollView *scrollView;
	ColorPageControl *pageControl;

	// data
	NSMutableArray *collections;
	NSMutableArray *grids;
	
	// fields
	int collectionsHeight;
	int nbOfItemsPerPage;
	float gridCellWidth;
	float gridCellHeight;
	
	// private
	@private
	BOOL pageControlIsChangingPage;
	int nbOfPages;
	int nbOfItems;

}

// Properties
@property (assign) id<P5PDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *collections;
@property (nonatomic, retain) UIView *scrollView;
@property (nonatomic, retain) ColorPageControl *pageControl;

// Business Methods
- (void)reloadCollections;

@end
