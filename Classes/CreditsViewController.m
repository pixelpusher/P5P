//
//  CreditsViewController.m
//  P5P
//
//  Created by CNPP on 25.2.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "CreditsViewController.h"
#import "Tracker.h"

/**
* CreditsViewController.
*/
@implementation CreditsViewController

#pragma mark -
#pragma mark View lifecycle

/*
* Loads the view.
*/
- (void)loadView {
	[super loadView];
	DLog();
	
	 // title
	self.navigationItem.title = [NSString stringWithFormat:@"%@", NSLocalizedString(@"Credits",@"Credits")];
	
	// remove background for iPhone
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.opaque = YES;
	self.tableView.backgroundView = nil;
	
	// init references
	references = [[NSMutableArray alloc] init];
	[references addObject:[[[Credit alloc] initWithName:@"Generative Gestaltung" meta:@"Hartmut Bohnacker, Benedikt Groß, Julia Laub, Claudius Lazzeroni" url:@"http://www.generative-gestaltung.de"] autorelease]]; 
	[references addObject:[[[Credit alloc] initWithName:@"FORM+CODE" meta:@"Casey Reas, Chandler McWilliams, and LUST" url:@"http://www.formandcode.com"] autorelease]]; 
	
	
	// init frameworks
	frameworks = [[NSMutableArray alloc] init];
	[frameworks addObject:[[[Credit alloc] initWithName:@"Processing" meta:@"Casey Reas, Ben Fry" url:@"http://www.processing.org"] autorelease]]; 
	[frameworks addObject:[[[Credit alloc] initWithName:@"Processing.js" meta:@"John Resig" url:@"http://www.processingjs.org"] autorelease]]; 

	// init tools
	components = [[NSMutableArray alloc] init];
	[components addObject:[[[Credit alloc] initWithName:@"AQGridView" meta:@"Alan Quatermain" url:@"http://github.com/AlanQuatermain/AQGridView"] autorelease]]; 
	[components addObject:[[[Credit alloc] initWithName:@"JSON Framework" meta:@"Stig Brautaset" url:@"http://stig.github.com/json-framework"] autorelease]]; 
	[components addObject:[[[Credit alloc] initWithName:@"Twitter+OAuth" meta:@"Ben Gottlieb" url:@"http://github.com/bengottlieb/Twitter-OAuth-iPhone"] autorelease]]; 
	[components addObject:[[[Credit alloc] initWithName:@"MGTwitterEngine" meta:@"Matt Gemmell" url:@"https://github.com/mattgemmell/MGTwitterEngine"] autorelease]];
	[components addObject:[[[Credit alloc] initWithName:@"PlainOAuth" meta:@"Jaanus Kase" url:@"https://github.com/jaanus/PlainOAuth"] autorelease]]; 
	[components addObject:[[[Credit alloc] initWithName:@"ASIHTTPRequest" meta:@"Ben Copsey" url:@"https://github.com/pokeb/asi-http-request"] autorelease]];  
	[components addObject:[[[Credit alloc] initWithName:@"OAuthConsumer" meta:@"Jon Crosby" url:@"http://code.google.com/p/oauth/"] autorelease]]; 
	[components addObject:[[[Credit alloc] initWithName:@"SMPageControl" meta:@"Simon Maddox" url:@"http://github.com/simonmaddox/SMPageControl"] autorelease]]; 
	[components addObject:[[[Credit alloc] initWithName:@"DoubleSlider" meta:@"Doukas Dimitris" url:@"https://github.com/doukasd/DoubleSlider"] autorelease]]; 
    [components addObject:[[[Credit alloc] initWithName:@"CMColorPicker" meta:@"Alex Restrepo" url:@"http://homepage.mac.com/alexrestrepo/indexmain.html"] autorelease]];

	
	
	// init assets
	assets = [[NSMutableArray alloc] init];
	[assets addObject:[[[Credit alloc] initWithName:@"Glyphish Icons" meta:@"Joseph Wain" url:@"http://glyphish.com"] autorelease]]; 
	[assets addObject:[[[Credit alloc] initWithName:@"iPad GUI PSD" meta:@"Geoff Teehan, Jon Lax" url:@"http://www.teehanlax.com/blog/2010/12/10/ipad-gui-psd-version-2/"] autorelease]]; 

}

/*
* Prepares the view.
*/
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	DLog();
	
	// track
	[Tracker trackPageView:[NSString stringWithFormat:@"/info/credits"]];

}


#pragma mark -
#pragma mark Cell Delegates

/*
* CellLink selected.
*/
- (void)cellLinkSelected:(CellLink *)c{
	FLog(@"url = %@",c.url);
	
	// track
	[Tracker trackEvent:TEventCredit action:@"Link" label:[NSString stringWithFormat:@"%@",c.url]];
	
	// open url
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:c.url]];
}


#pragma mark -
#pragma mark Table view data source

/*
 * Customize the number of sections in the table view.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
	// count it
    return 4;
}


/*
 * Customize the number of rows in the table view.
 */
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {

    // section
    switch (section) {
		case SectionCreditsReferences: {
			return [references count];
		}
		case SectionCreditsFrameworks: {
			return [frameworks count];
		}
        case SectionCreditsComponents: {
			return [components count];
		}
		case SectionCreditsAssets: {
			return [assets count];
		}
    }
    
    return 0;
}



#pragma mark -
#pragma mark UITableViewDelegate Protocol


/*
 * Section titles.
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	// section
    switch (section) {
		case SectionCreditsReferences: {
			return NSLocalizedString(@"References",@"References");
		}
		case SectionCreditsFrameworks: {
			return NSLocalizedString(@"Frameworks",@"Frameworks");
		}
        case SectionCreditsComponents: {
			return NSLocalizedString(@"Components",@"Components");
		}
		case SectionCreditsAssets: {
			return NSLocalizedString(@"Assets",@"Assets");
		}
    }
    
    return nil;
}


/*
 * Customize the appearance of table view cells.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	// identifiers
    static NSString *CellIdentifier = @"CellCredits";
	
	// create cell
	CellLink *cell = (CellLink*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[CellLink alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
	
	// configure
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0]; 
	cell.textLabel.textColor = [UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0];
	
	// credits
	Credit *c;
	if ([indexPath section] == SectionCreditsReferences) {
		c = [references objectAtIndex:[indexPath row]];
	}
	else if ([indexPath section] == SectionCreditsFrameworks) {
		c = [frameworks objectAtIndex:[indexPath row]];
	}
	else if ([indexPath section] == SectionCreditsComponents) {
		c = [components objectAtIndex:[indexPath row]];
	}
	else if ([indexPath section] == SectionCreditsAssets) {
		c = [assets objectAtIndex:[indexPath row]];
	}
	
	cell.delegate = self;
	cell.url = c.url;
	cell.textLabel.text = c.name;
	cell.detailTextLabel.text = c.meta;
	
	// return
    return cell;
}




#pragma mark -
#pragma mark Memory management



/**
* Deallocates all used memory.
*/
- (void)dealloc {
	GLog();
	
	// data
	[references release];
	[frameworks release];
	[components release];
	[assets release];
	
	// duper
    [super dealloc];
}

@end



/**
 * Credit.
 */
@implementation Credit

#pragma mark -
#pragma mark Properties

// accessors
@synthesize name;
@synthesize meta;
@synthesize url;


#pragma mark -
#pragma mark Object

/**
* Init.
*/
- (id)initWithName:(NSString*)n meta:(NSString*)m url:(NSString*)u {
	GLog();
	if ((self = [super init])) {
		self.name = n;
		self.meta = m;
		self.url = u;
		return self;
	}
	return nil;
}


#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
	
	// self
	[name release];
	[meta release];
	[url release];
	
	// super
    [super dealloc];
}

@end
