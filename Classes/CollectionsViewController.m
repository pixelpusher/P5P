//
//  CollectionsViewController.m
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

#import "CollectionsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "P5PAppDelegate.h"
#import "P5PConstants.h"
#import "AQGridView.h"
#import "GridCellCollection.h"
#import "Collection.h"
#import "Tracker.h"


/**
* CollectionsViewController.
*/
@implementation CollectionsViewController


#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;
@synthesize collections;
@synthesize scrollView;
@synthesize pageControl;



#pragma mark -
#pragma mark Object Methods

/**
* Init.
*/
- (id)init {
	
	// init super
	if (self = [super init]) {
		GLog();
	
		// field defaults
		collectionsHeight = 115;
		nbOfItemsPerPage = 3;
		nbOfItems = 0;
		gridCellWidth = 120;
		gridCellHeight = 115;
		
		// return
		return self;
	}
	
	// noooooooooooooo
	return nil;
}


#pragma mark -
#pragma mark View lifecycle

/*
 * Loads the view.
 */
- (void)loadView {
	[super loadView];
	DLog();
	
	// view
	self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, collectionsHeight);
	float swidth = self.view.frame.size.width;
	float sheight = collectionsHeight;
	
	// background 
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_collections.png"]];
	
	// drop that shadow
	CAGradientLayer *dropShadow = [[[CAGradientLayer alloc] init] autorelease];
	dropShadow.frame = CGRectMake(0, 0, swidth, 12);
	dropShadow.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:0.21 alpha:1.0].CGColor,(id)[UIColor colorWithWhite:0.21 alpha:0].CGColor,nil];
	[self.view.layer insertSublayer:dropShadow atIndex:0];
	
	// page control
	ColorPageControl *pControl = [[ColorPageControl alloc] initWithFrame:CGRectMake(0, sheight-20, swidth, 20)];
	pControl.backgroundColor = [UIColor clearColor];
	pControl.inactivePageColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1.0];
	pControl.activePageColor = [UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0];
	pControl.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	self.pageControl = pControl;
	[self.view addSubview:pageControl];
	
	// scroll view
	UIScrollView *sView = [[UIScrollView alloc] initWithFrame:self.view.frame];
	sView.delegate = self;
	sView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	sView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	sView.clipsToBounds = YES;
	sView.scrollEnabled = YES;
	sView.pagingEnabled = YES;
	self.scrollView = sView;
	[self.view addSubview:scrollView];
	[sView release];
	
	// reload
	[self reloadCollections];

}


/*
* Prepares the view.
*/
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	DLog();
	
	// track
	[Tracker trackPageView:[NSString stringWithFormat:@"/collections"]];
	
	// reload
	for (AQGridView *grid in grids){
		[grid reloadData];
	}
}


#pragma mark -
#pragma mark Business Methods

/**
* Reloads the collections.
*/
- (void)reloadCollections {
	DLog();
	
	
	// load sketches
	P5PAppDelegate *appDelegate = (P5PAppDelegate*)[[UIApplication sharedApplication] delegate];
	self.collections = [appDelegate loadCollections];
	
	// parameters
	nbOfItems = [collections count];
	nbOfPages = 1 + (int) nbOfItems / nbOfItemsPerPage;
	float swidth = self.view.frame.size.width;
	float sheight = collectionsHeight;

	
	// page control
	pageControl.numberOfPages = nbOfPages;
	pageControl.currentPage = 0;
	
	// scroll view
	[scrollView setContentSize:CGSizeMake(nbOfPages * swidth, sheight)];


	// grid views
	grids = [[NSMutableArray alloc] init];
	for (int p = 0; p < nbOfPages; p++) {
		
		// init
		float gx = p * swidth;
		AQGridView *gridView = [[[AQGridView alloc] initWithFrame:CGRectMake(gx, 0, nbOfItemsPerPage * gridCellWidth, sheight)] autorelease];
		gridView.dataSource = self;
		gridView.delegate = self;
		gridView.pageIndex = p;

		// configure
		gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		gridView.autoresizesSubviews = YES;
		gridView.backgroundColor = [UIColor clearColor];
		gridView.opaque = NO;
		gridView.scrollEnabled = NO;
		//gridView.leftContentInset = 20.0;
		//gridView.rightContentInset = 20.0;
    
		// add grid 
		[grids addObject:gridView];
		[scrollView addSubview: gridView];
		[gridView release];
	}
	
}



#pragma mark -
#pragma mark UIScrollViewDelegate stuff

/*
* Scrolling.
*/
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView {
	
	// safety check
    if (pageControlIsChangingPage) {
        return;
    }

	// switch page at 50% across
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView {
	// flag
    pageControlIsChangingPage = NO;
}


#pragma mark -
#pragma mark PageControl stuff

/*
* Paging.
*/
- (IBAction)changePage:(id)sender {
	
	// scroll into view
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];

	// flag
    pageControlIsChangingPage = YES;
}



#pragma mark -
#pragma mark GridView Data Source

/*
 * Number of grid items.
 */
- (NSUInteger)numberOfItemsInGridView: (AQGridView *) gridView {
	GLog();
	return nbOfItemsPerPage;
}

/*
 * Customize the appearance of grid cells.
 */
- (AQGridViewCell*)gridView:(AQGridView *)gridView cellForItemAtIndex:(NSUInteger)index {
	GLog();
	
	// identifiers
	static NSString *CellIdentifier = @"GridCellCollection";
	static NSString *EmptyIdentifier = @"GridCellCollectionEmpty";
	CGRect cellFrame = CGRectMake(0.0, 0.0, gridCellWidth, gridCellHeight);
	if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ) {
		// landscape
		cellFrame = CGRectMake(0.0, 0.0, gridCellHeight, gridCellWidth);
	}
	
	// item index
	int itemIndex = (gridView.pageIndex * nbOfItemsPerPage) + index;
	
	// empty cell
	if (itemIndex >= nbOfItems) {
		GLog(@"empty cell");
		
		AQGridViewCell * hiddenCell = [gridView dequeueReusableCellWithIdentifier: EmptyIdentifier];
		if ( hiddenCell == nil ) {
            // must be the SAME SIZE AS THE OTHERS
            hiddenCell = [[[AQGridViewCell alloc] initWithFrame:cellFrame reuseIdentifier: EmptyIdentifier] autorelease];
		}
		hiddenCell.hidden = YES;
		return hiddenCell;
	}
	
	// collection
	Collection *collection = [collections objectAtIndex:itemIndex];
	GLog(@"collection = %@",collection.name);
	
	// preferences
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	BOOL collectionDisabled = [userDefaults boolForKey:[NSString stringWithFormat:@"%@_%@",udCollectionDisabled,collection.cid]];
	

	// collection cell
    GridCellCollection * cell = (GridCellCollection *)[gridView dequeueReusableCellWithIdentifier: CellIdentifier];
    if (cell == nil ) {
        cell = [[[GridCellCollection alloc] initWithFrame:cellFrame reuseIdentifier: CellIdentifier] autorelease];
    }
	
	
    
    // configure & return
	[cell setDisabled:collectionDisabled];
    cell.collectionTitle.text = [NSString stringWithFormat:@"%@", collection.name];
	[cell collectionImageRounded:[UIImage imageNamed: collection.thumb]];
    return cell;
}

- (CGSize)portraitGridCellSizeForGridView: (AQGridView*) gridView {
    return ( CGSizeMake(gridCellWidth, gridCellHeight) );
}
- (CGSize)landscapeGridCellSizeForGridView: (AQGridView*) gridView {
    return ( CGSizeMake(gridCellHeight, gridCellWidth) );
}



#pragma mark -
#pragma mark GridView Delegate


/**
* GridCell selected.
*/
- (void)gridView:(AQGridView*)gridView didSelectItemAtIndex:(NSUInteger)index {
	FLog(@"index = %i", index);
	
	// item index
	int itemIndex = (gridView.pageIndex * nbOfItemsPerPage) + index;
	
	// constraint
	if (itemIndex >= nbOfItems) {
		return;
	}
	
	// cell
	GridCellCollection *cell = (GridCellCollection*) [gridView cellForItemAtIndex:index];
	[cell setDisabled:!cell.disabled];

	// enable / disable collection
	Collection *collection = [collections objectAtIndex:itemIndex];
	P5PAppDelegate *appDelegate = (P5PAppDelegate*)[[UIApplication sharedApplication] delegate];
	[appDelegate disableCollection:collection.cid disabled:cell.disabled];
	
	// reload
	[gridView resetSelection];
	[gridView reloadData];
}




#pragma mark -
#pragma mark Memory management


/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
	
	// ui
	[scrollView release];
	[pageControl release];
	
	// fields
	[collections release];
	[grids release];
	
	// super
    [super dealloc];
}

@end
