//
//  CollectionsViewController.h
//  P5P
//
//  Created by CNPP on 24.2.2011.
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
