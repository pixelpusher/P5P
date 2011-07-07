//
//  SketchesViewController.h
//  P5P
//
//  Created by CNPP on 28.1.2011.
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
