//
//  SketchesViewController.m
//  P5P
//
//  Created by CNPP on 28.1.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "SketchesViewController.h"
#import "P5PAppDelegate.h"
#import "Sketch.h"
#import "GridCellSketch.h"
#import "Tracker.h"




/**
* SketchesViewController.
*/
@implementation SketchesViewController


#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;
@synthesize sketches;
@synthesize scrollView;
@synthesize pageControl;
@synthesize buttonInfo;
@synthesize buttonCollections;


#pragma mark -
#pragma mark Object Methods

/**
* Init.
*/
- (id)init {
	GLog();
	
	// init super
	if (self = [super init]) {
	
		// field defaults
		nbOfItemsPerPage = 9;
		gridCellWidth = 210;
		gridCellHeight = 325;
		
		// return
		return self;
	}
	
	// oh oh
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
	
	// size
	float swidth = self.view.frame.size.width;
	float sheight = self.view.frame.size.height;
	
	 // background 
    UIImageView *background = [[UIImageView alloc] initWithFrame: self.view.bounds];
    background.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    background.contentMode = UIViewContentModeCenter;
	background.contentMode = UIViewContentModeRedraw;
    background.image = [UIImage imageNamed: @"bg_sketches.png"];
	[self.view addSubview: background];
	
	// page control
	ColorPageControl *pControl = [[ColorPageControl alloc] initWithFrame:CGRectMake(0, sheight-50, swidth, 50)];
	pControl.backgroundColor = [UIColor clearColor];
	pControl.inactivePageColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:1.0];
	pControl.activePageColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1.0];
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
	
	// buttons
	float buttonSize = 50;
	
	
	// button info
	UIButton *btnInfo = [UIButton buttonWithType:UIButtonTypeCustom]; 
	btnInfo.frame = CGRectMake(swidth-buttonSize, sheight-buttonSize, buttonSize, buttonSize);
	[btnInfo setImage:[UIImage imageNamed:@"btn_info.png"] forState:UIControlStateNormal];
	[btnInfo addTarget:self action:@selector(actionInfo:) forControlEvents:UIControlEventTouchUpInside];
	self.buttonInfo = btnInfo;
	[self.view addSubview:buttonInfo];
	[btnInfo release];
	
	// button collections
	UIButton *btnCollections = [UIButton buttonWithType:UIButtonTypeCustom]; 
	btnCollections.frame = CGRectMake(0, sheight-buttonSize, buttonSize, buttonSize);
	[btnCollections setImage:[UIImage imageNamed:@"btn_collections.png"] forState:UIControlStateNormal];
	[btnCollections addTarget:self action:@selector(actionCollections:) forControlEvents:UIControlEventTouchUpInside];
	self.buttonCollections = btnCollections;
	[self.view addSubview:buttonCollections];
	[btnCollections release];
	
	
	// reload
	grids = [[NSMutableArray alloc] init];
	[self reloadSketches];

}



/*
* Prepares the view.
*/
- (void)viewWillAppear:(BOOL)animated {
	DLog();
	
	// track
	[Tracker trackPageView:[NSString stringWithFormat:@"/sketches"]];
	
	// reload
	for (AQGridView *grid in grids){
		[grid resetSelection];
		[grid reloadData];
	}
}


#pragma mark -
#pragma mark Business Methods

/**
* Reloads the sketches.
*/
- (void)reloadSketches {
	DLog();
	
	// load sketches
	P5PAppDelegate *appDelegate = (P5PAppDelegate*)[[UIApplication sharedApplication] delegate];
	self.sketches = [appDelegate loadSketches];
	
	// parameters
	nbOfItems = [sketches count];
	nbOfPages = 1 + (int) (nbOfItems-1) / nbOfItemsPerPage;
	float swidth = self.view.frame.size.width;
	float sheight = self.view.frame.size.height;

	
	// page control
	pageControl.numberOfPages = nbOfPages;
	pageControl.currentPage = 0;
	
	// remove subviews
	for(UIView *subview in [scrollView subviews]) {
		[subview removeFromSuperview];
	}
	
	// scroll view
	[scrollView setContentSize:CGSizeMake(nbOfPages * swidth, sheight)];


	// grid views
	[grids removeAllObjects];
	for (int p = 0; p < nbOfPages; p++) {
		
		// init
		float gx = p * swidth;
		AQGridView *gridView = [[[AQGridView alloc] initWithFrame:CGRectMake(gx, 25, swidth, sheight-50)] autorelease];
		gridView.dataSource = self;
		gridView.delegate = self;
		gridView.pageIndex = p;

		// configure
		gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		gridView.autoresizesSubviews = YES;
		gridView.backgroundColor = [UIColor clearColor];
		gridView.opaque = NO;
		gridView.scrollEnabled = NO;
		//gridView.leftContentInset = 1.0;
		//gridView.rightContentInset = 1.0;
    
		// add grid 
		[grids addObject:gridView];
		[scrollView addSubview: gridView];
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
#pragma mark Actions


/*
* Information.
*/
- (void)actionInfo:(id)sender {
	DLog();
	
	// info view controller
	InfoViewController *nfoController = [[InfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
	nfoController.delegate = self;
	nfoController.view.frame = CGRectMake(0, 0, 320, 480);
	[nfoController.view setAutoresizingMask: (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight) ];

 
	// navigation controller
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:nfoController];
	navController.view.backgroundColor = [UIColor colorWithRed:219.0/255.0 green:222.0/255.0 blue:227.0/255.0 alpha:1.0];

 
	// ipad
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		navController.modalPresentationStyle = UIModalPresentationFormSheet;
	}
	// iphone
	else {
		navController.navigationBar.barStyle = UIBarStyleBlack;
	}

	
	// show the navigation controller modally
	[navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
	[self presentModalViewController:navController animated:YES];
 
	// Clean up resources
	[navController release];
	[nfoController release];
}

/*
* Information.
*/
- (void)actionCollections:(id)sender {
	DLog();
	
	// delegate
	if (delegate != NULL && [delegate respondsToSelector:@selector(toggleCollections)]) {
		[delegate toggleCollections];
	}
	
}




#pragma mark -
#pragma mark InfoDelegate

/*
 * Dismiss info.
 */
- (void)dismissInfo {
	FLog();
	
	// dismiss modal
	[self dismissModalViewControllerAnimated:YES];
}


/*
 * Returns a random sketch image.
 */
- (UIImage*)randomSketchImage {
	FLog();
	
	// image
	UIImage *rimg = [UIImage imageNamed:@"Default.png"];
	
	// sketch
	if ([sketches count] > 0) {
		Sketch *s = [sketches objectAtIndex:random() % [sketches count]];
		rimg = [UIImage imageNamed:s.thumb];
	}
	
	// return
	return rimg;
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
	static NSString *CellIdentifier = @"GridCellSketch";
	static NSString *EmptyIdentifier = @"GridCellSketchEmpty";
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
	

	// sketch cell
    GridCellSketch * cell = (GridCellSketch *)[gridView dequeueReusableCellWithIdentifier: CellIdentifier];
    if (cell == nil ) {
        cell = [[[GridCellSketch alloc] initWithFrame:cellFrame reuseIdentifier: CellIdentifier] autorelease];
    }
	
	
    
    // configure & return
	Sketch *sketch = [sketches objectAtIndex:itemIndex];
	GLog(@"sketch = %@",sketch.name);
    cell.sketchTitle.text = [NSString stringWithFormat:@"%@", sketch.name];
	cell.sketchMeta.text = [NSString stringWithFormat:@"%@", sketch.meta];
	cell.sketchImage.image = [UIImage imageNamed: sketch.thumb];
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
	
	// delegate
	if (delegate != NULL && [delegate respondsToSelector:@selector(navigateToSketch:)]) {
		[delegate navigateToSketch:[sketches objectAtIndex:itemIndex]];
	}
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
	[buttonInfo release];
	[buttonCollections release];
	
	// fields
	[sketches release];
	[grids release];
	
	// super
    [super dealloc];
}


@end
