//
//  AccountTwitterViewController.m
//  P5P
//
//  Created by CNPP on 24.3.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
#import "AccountTwitterViewController.h"



/**
* AccountTwitterViewController.
*/
@implementation AccountTwitterViewController


#pragma mark -
#pragma mark UIViewController Methods


/*
* Loads the view.
*/
- (void)loadView {
	[super loadView];
	DLog();
	
	 // title
	self.navigationItem.title = [NSString stringWithFormat:@"%@", NSLocalizedString(@"Twitter Account",@"Twitter Account")];
	
	
	// prepare table view
	self.tableView.scrollEnabled = NO;
	
	// remove background for iPhone
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.opaque = YES;
	self.tableView.backgroundView = nil;
	
	// twitter
	twitterAPI = [[TwitterAPI alloc] init];
	twitterAPI.delegate = self;
}




#pragma mark -
#pragma mark Action Methods

/*
 * Authenticate.
 */
- (void)actionConnectAccount:(id)sender {
	DLog();
	
	// authenticate
	[twitterAPI authenticate];
}

/*
 * Remove.
 */
- (void)actionRemoveAccount:(id)sender {
	DLog();
	

	// remove
	[twitterAPI remove];
	
	// reload
	[self.tableView reloadData];
	
	// show info
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:NSLocalizedString(@"Removed Account",@"Removed Account")
						  message:NSLocalizedString(@"Your Twitter Account has been removed. To completely revoke access you need to visit the Connection Settings on the Twitter website. Sorry for the inconvenience.",@"Your Twitter Account has been removed. To completely revoke access you need to visit the Connection Settings on the Twitter website. Sorry for the inconvenience.")
						  delegate:self 
						  cancelButtonTitle:NSLocalizedString(@"OK",@"OK")
						  otherButtonTitles:NSLocalizedString(@"Visit Twitter",@"Visit Twitter"),nil];
	[alert show];    
	[alert release];
	
}

#pragma mark -
#pragma mark TwitterAPI Delegate


/**
 * Present authentication dialog.
 */
- (void)twitterAuthentication:(UIViewController *)controller {
	DLog();
	
	// show authentication
	[self presentModalViewController: controller animated: YES];
}

/**
 * Success.
 */
- (void)twitterAuthenticationSuccess:(NSString*)username {
	DLog();
	
	// reload
	[self.tableView reloadData];
}




#pragma mark -
#pragma mark Table view data source


/*
 * Table View Sections.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


/*
 * Table View Rows.
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // section
    switch (section) {
		case SectionAccountTwitter: {
			if ([TwitterAPI authenticated]) {
				return 1;
			}
			return 0;
		}
		case SectionAccountTwitterAuthenticate: {
			return 1;
		}
    }
	return 0;
}

/*
 * Section titles.
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	// section
    switch (section) {
		case SectionAccountTwitter: {
			return NSLocalizedString(@"Twitter Account",@"Twitter Account");
		}
    }
    
    return nil;
}

/*
 * Table header.
 */
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection: (NSInteger) section {
	

	// header
	if (! [TwitterAPI authenticated] && section == SectionAccountTwitter) {
		
		//  view
		CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
		UIView* footerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 30.0)];
		footerview.autoresizesSubviews = YES;
		footerview.autoresizingMask = UIViewAutoresizingFlexibleWidth;		
		footerview.hidden = NO;
		footerview.multipleTouchEnabled = NO;
		footerview.opaque = NO;
		footerview.contentMode = UIViewContentModeScaleToFill;
		
		
		// message
		float inset = 20;
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			inset = 40;
		} 
		UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(inset, 0, footerview.frame.size.width-2*inset, 20)];
		messageLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
		messageLabel.textColor = [UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0];
		messageLabel.shadowColor = [UIColor whiteColor];
		messageLabel.shadowOffset = CGSizeMake(1,1);
		messageLabel.backgroundColor = [UIColor clearColor];
		messageLabel.opaque = YES;
		messageLabel.numberOfLines = 2;
		[messageLabel setText:NSLocalizedString(@"Connect your Twitter Account with P5P.","Connect your Twitter Account with P5P.")];
		
		// add to view
		[footerview addSubview: messageLabel];
		[messageLabel release];
		
		// return
		return footerview;
	}
	
	// nil
	return nil;

}
/*
 * Height for header.
 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { 
	
	// height
	if(! [TwitterAPI authenticated] && section == SectionAccountTwitter) { 
		return 30; 
	} 
	return 0; 
}


/*
 * Table View Cells.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	// identifier
	static NSString *CellIdentifier = @"CellTwitter";
	
    //  section
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
	}
	
	
	// section
    NSUInteger section = [indexPath section];
    switch (section) {
			
		// account
        case SectionAccountTwitter: {
			FLog("SectionAccountTwitter");
			
			// defaults
			NSString *username = [TwitterAPI username];
			
			// cell
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			[cell.textLabel setText:NSLocalizedString(@"Username",@"Username")];
			[cell.detailTextLabel setText:username];
			[cell.detailTextLabel setTextColor:[UIColor grayColor]];
			
			// view
			cell.accessoryView = nil;
			
			// break
			break;
		}
			
		// authenticate
        case SectionAccountTwitterAuthenticate: {
			FLog("SectionAccountTwitterAuthenticate");
				
			// button
			int strangeoffset = 19;
			if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
				strangeoffset = 60;
			}
			UIButton *twitterAuthenticate = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			twitterAuthenticate.frame = CGRectMake(0, 0, self.view.frame.size.width-strangeoffset, 45); 

			
			// authenticate
			if ([TwitterAPI authenticated]) {
				// authenticate
				[twitterAuthenticate setTitle:NSLocalizedString(@"Remove Account",@"Remove Account") forState:UIControlStateNormal];
				
				// targets and actions
				[twitterAuthenticate addTarget:self action:@selector(actionRemoveAccount:) forControlEvents:UIControlEventTouchUpInside];
			}
			else {				
				// authenticate
				[twitterAuthenticate setTitle:NSLocalizedString(@"Connect",@"Connect") forState:UIControlStateNormal];
				
				// targets and actions
				[twitterAuthenticate addTarget:self action:@selector(actionConnectAccount:) forControlEvents:UIControlEventTouchUpInside];
			}

			
			// prepare cell
			cell.accessoryView = twitterAuthenticate;
			
			// break
			break;

		}
			
	}	
	
	// prepare cell
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0]; 
	cell.textLabel.textColor = [UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0];
	
	// return
	return cell;
	
}

#pragma mark -
#pragma mark UIAlertViewDelegate Delegate

/*
 * Alert view button clicked.
 */
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	FLog();
	
	// cancel
	if (buttonIndex == 0) {
	}
	// visit twitter
	else {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://api.twitter.com/settings/connections"]];
	}
	
	
}


#pragma mark -
#pragma mark Memory Management


/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	[twitterAPI release];
    [super dealloc];
}


@end
