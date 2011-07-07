//
//  InfoViewController.m
//  P5P
//
//  Created by CNPP on 17.2.2011.
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

#import "InfoViewController.h"
#import "P5PAppDelegate.h"
#import "P5PConstants.h"
#import "CreditsViewController.h"
#import "PreferencesViewController.h"
#import	"Tracker.h"


/*
* Helper Stack.
*/
@interface InfoViewController (Helpers)
- (void)recommendEmail;
- (void)recommendTwitter;
- (void)recommendAppStore;
- (void)feedbackEmail;
@end

/**
* Info Controller.
*/
@implementation InfoViewController


#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;


#pragma mark -
#pragma mark View lifecycle


/*
* Loads the view.
*/
- (void)loadView {
	[super loadView];
	DLog();
	
	 // title
	self.navigationItem.title = [NSString stringWithFormat:@"%@", NSLocalizedString(@"P5P Generative Sketches",@"P5P Generative Sketches")];
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
		self.navigationItem.title = [NSString stringWithFormat:@"%@", NSLocalizedString(@"P5P",@"P5P")];
	}
	
	// navigation bar: done button
	UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] 
								   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
								   target:self 
								   action:@selector(actionDone:)];
	self.navigationItem.rightBarButtonItem = btnDone;
	[btnDone release];
	
	// prepare table view
	self.tableView.scrollEnabled = NO;
	
	// remove background for iPhone
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.opaque = YES;
	self.tableView.backgroundView = nil;
	
	// about 
	float height = 110;
    float width = 540;
	float inset = 40;
    float margin = 15;
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
		height = 150;
        width = 320;
		inset = 20;
        margin = 10;
	}
	UIView *aboutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];

	
	// description
	UILabel *lblAbout = [[UILabel alloc] initWithFrame:CGRectMake(inset, margin, width-2*inset, height-margin)];
	lblAbout.backgroundColor = [UIColor clearColor];
	lblAbout.font = [UIFont fontWithName:@"Helvetica" size:15.0];
	lblAbout.textColor = [UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0];
	lblAbout.shadowColor = [UIColor whiteColor];
	lblAbout.shadowOffset = CGSizeMake(1,1);
	lblAbout.opaque = YES;
	lblAbout.numberOfLines = 4;
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
		lblAbout.numberOfLines = 7;
	}
	[lblAbout setText:NSLocalizedString(@"P5P is a collection of generative sketches. The interactive visuals are each defined by a set of rules and computed by randomly modified algorithms. Adjust and tweak their parameters, touch or move the device to influence the outcome of the generated images.",@"P5P is a collection of generative sketches. The interactive visuals are each defined by a set of rules and computed by randomly modified algorithms. Adjust and tweak their parameters, touch or move the device to influence the outcome of the generated images.")];
	[aboutView addSubview:lblAbout];
	[lblAbout release];

	// table header
	self.tableView.tableHeaderView = aboutView;
	
	
	// note view
	NoteView *nv = [[NoteView alloc] initWithFrame:self.view.frame];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		// strange days
		nv.bounds = CGRectMake(-200, -200, self.view.frame.size.width, self.view.frame.size.height);
	}
	[nv setAutoresizingMask: (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight) ];
	
	// set and add to view 
	note = [nv retain];
	[self.view addSubview:note];
	[self.view bringSubviewToFront:note];
	[nv release];

}

/*
* Prepares the view.
*/
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	DLog();
	
	// track
	[Tracker trackPageView:[NSString stringWithFormat:@"/info"]];
}


#pragma mark -
#pragma mark Actions

/*
* Processing reset.
*/
- (void)actionDone:(id)sender {
	DLog();
	
	// dismiss
	if (delegate != nil && [delegate respondsToSelector:@selector(dismissInfo)]) {
		[delegate dismissInfo];
	}
}


#pragma mark -
#pragma mark Cell Delegates

/*
* CellButton.
*/
- (void)cellButtonTouched:(CellButton *)c {
	GLog();
	
	// reset
	switch ([c tag]) {
		
		// recommend
		case InfoActionRecommend:{
		
			// track
			[Tracker trackEvent:TEventInfo action:@"Recommend" label:[NSString stringWithFormat:@"%@",[(P5PAppDelegate*)[[UIApplication sharedApplication] delegate] getUserDefault:udInformationAppVersion]]];
	
			// action sheet
			UIActionSheet *recommendAction = [[UIActionSheet alloc]
								  initWithTitle:NSLocalizedString(@"Recommend P5P",@"Recommend P5P")
								  delegate:self
								  cancelButtonTitle:NSLocalizedString(@"Cancel",@"Cancel")
								  destructiveButtonTitle:nil
								  otherButtonTitles:NSLocalizedString(@"Email",@"Email"),NSLocalizedString(@"Twitter",@"Twitter"),NSLocalizedString(@"App Store",@"App Store"),nil];
	
			// show
			[recommendAction setTag:InfoActionRecommend];
			[recommendAction showInView:self.navigationController.view];
			[recommendAction release];
			break;
		}
		
		// feedback
		case InfoActionFeedback:{
		
			// track
			[Tracker trackEvent:TEventInfo action:@"Feedback" label:[NSString stringWithFormat:@"%@",[(P5PAppDelegate*)[[UIApplication sharedApplication] delegate] getUserDefault:udInformationAppVersion]]];
			
			// feedback
            [self feedbackEmail];
			break;
		}
		
		default:
			break;
	}


}



#pragma mark -
#pragma mark UIActionSheet Delegate

/*
 * Action selected.
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	DLog();
	
	// tag
	switch ([actionSheet tag]) {
	
		// recommend
		case InfoActionRecommend: {
			// email
			if (buttonIndex == 0) {
				[self recommendEmail];
			} 
			// email
			if (buttonIndex == 1) {
				[self recommendTwitter];
			} 
			// app store
			if (buttonIndex == 2) {
				[self recommendAppStore];
			} 
			break;
		}
		
		
		// default
		default: {
			break;
		}
	}
	
	
}


#pragma mark -
#pragma mark Helpers


/*
* Recommend Email.
*/
- (void)recommendEmail {
	DLog();
	
	// track
	[Tracker trackEvent:TEventRecommend action:@"Email" label:[NSString stringWithFormat:@"%@",[(P5PAppDelegate*)[[UIApplication sharedApplication] delegate] getUserDefault:udInformationAppVersion]]];
	
	// check mail support
	if (! [MFMailComposeViewController canSendMail]) {

		// note
		[note noteError:@"Email not configured." ];
		[note showNote];
		[note dismissNoteAfterDelay:2.4];

	}
	else {
		
		// mail composer
		MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
		composer.mailComposeDelegate = self;
        composer.navigationBar.barStyle = UIBarStyleBlack;
		
		// subject
		[composer setSubject:[NSString stringWithFormat:@"P5P iPad/iPhone App"]];
	 
		// message
		NSString *message = NSLocalizedString(@"\n\n\n---\nP5P\nA Collection of Generative Sketches.\nhttp://p5p.cecinestpasparis.net",@"\n\n\n---\nP5P\nA Collection of Generative Sketches.\nhttp://p5p.cecinestpasparis.net");
		[composer setMessageBody:message isHTML:NO];
		
		// promo image
		UIImage *pimg = [delegate randomSketchImage];
		NSData *data = UIImagePNGRepresentation(pimg);
		[composer addAttachmentData:data mimeType:@"image/png" fileName:@"P5P"];

	 
		// show off
		[self presentModalViewController:composer animated:YES];
	 
		// release
		[composer release];
		
	}
}

/*
* Recommend Twitter.
*/
- (void)recommendTwitter {
	DLog();
	
	// track
	[Tracker trackEvent:TEventRecommend action:@"Twitter" label:[NSString stringWithFormat:@"%@",[(P5PAppDelegate*)[[UIApplication sharedApplication] delegate] getUserDefault:udInformationAppVersion]]];
	
	
	// twitter compose
	TwitterComposeViewController *twitterCompose = [[TwitterComposeViewController alloc] initWithFrame:self.view.frame];
	twitterCompose.delegate = self;
	
	// message
	NSString *message = NSLocalizedString(@"P5P iPad/iPhone App. A Collection of Generative Sketches. http://p5p.cecinestpasparis.net",@"P5P iPad/iPhone App. A Collection of Generative Sketches. http://p5p.cecinestpasparis.net");
	[twitterCompose setStatusText:message];
	
	// promo image
	UIImage *pimg = [delegate randomSketchImage];
	[twitterCompose setStatusImage:pimg message:NSLocalizedString(@"Generated with P5P. \nhttp://p5p.cecinestpasparis.net",@"Generated with P5P. \nhttp://p5p.cecinestpasparis.net")];
	
	// show controller
	[UIView beginAnimations:@"twitter_compose" context:nil];
	[UIView setAnimationDuration:0.6];
	[self.navigationController pushViewController: twitterCompose animated:NO]; 
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO]; 
	[UIView commitAnimations];
}

/*
* Recommend App Store.
*/
- (void)recommendAppStore {
	DLog();
	
	// track
	[Tracker trackEvent:TEventRecommend action:@"AppStore" label:[NSString stringWithFormat:@"%@",[(P5PAppDelegate*)[[UIApplication sharedApplication] delegate] getUserDefault:udInformationAppVersion]]];
	
	// show info
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"App Store" 
						  message:NSLocalizedString(@"Thank you for rating P5P or writing a nice review.",@"Thank you for rating P5P or writing a nice review.")
						  delegate:self 
						  cancelButtonTitle:NSLocalizedString(@"Maybe later",@"Maybe later")
						  otherButtonTitles:NSLocalizedString(@"Visit",@"Visit"),nil];
	[alert setTag:InfoAlertRecommendAppStore];
	[alert show];    
	[alert release];

}


/*
* Feedback Email.
*/
- (void)feedbackEmail {
	DLog();
	
	// track
	[Tracker trackEvent:TEventFeedback action:@"Email" label:[NSString stringWithFormat:@"%@",[(P5PAppDelegate*)[[UIApplication sharedApplication] delegate] getUserDefault:udInformationAppVersion]]];
	
	// check mail support
	if (! [MFMailComposeViewController canSendMail]) {

		// note
		[note noteError:@"Email not configured." ];
		[note showNote];
		[note dismissNoteAfterDelay:2.4];

	}
	else {
		
		// mail composer
		MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
		composer.mailComposeDelegate = self;
        composer.navigationBar.barStyle = UIBarStyleBlack;
		
		// subject
		[composer setToRecipients:[[[NSArray alloc] initWithObjects:vAppEmail,nil] autorelease]];
		
		// subject
		[composer setSubject:[NSString stringWithFormat:@"[P5P] Feedback"]];
	 
		// show off
		[self presentModalViewController:composer animated:YES];
	 
		// release
		[composer release];
		
	}
}



#pragma mark -
#pragma mark UIAlertViewDelegate Delegate

/*
 * Alert view button clicked.
 */
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	FLog();
	
	// tag
	switch ([actionSheet tag]) {
	
		// recommend App Store
		case InfoAlertRecommendAppStore: {
			// cancel
			if (buttonIndex == 0) {
			}
			// visit app store
			else {
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id443413228"]];
			}
			break;
		}

		
		// default
		default: {
			break;
		}
	}
	
}



#pragma mark -
#pragma mark TwitterComposeDelegate Protocol

/*
 * Dismisses the twitter composition interface when users tap Cancel or Send.
 */
- (void)dismissTwitterCompose {
	DLog();
	
	// hide that thing	
	[UIView beginAnimations:@"twitter_dismiss" context:nil];
	[UIView setAnimationDuration:0.6];
	[self.navigationController popViewControllerAnimated:NO];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO]; 
	[UIView commitAnimations];
	
}



#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate Protocol

/*
 * Dismisses the email composition interface when users tap Cancel or Send.
 */
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {	
	FLog();
	
	// result
	switch (result) {
		case MFMailComposeResultCancelled:
			FLog(@"Email: canceled");
			break;
		case MFMailComposeResultSaved:
			FLog(@"Email: saved");
			break;
		case MFMailComposeResultSent:
			FLog(@"Email: sent");
			break;
		case MFMailComposeResultFailed:
			FLog(@"Email: failed");
			break;
		default:
			FLog(@"Email: not sent");
			break;
	}
	
	// close modal
	[self dismissModalViewControllerAnimated:YES];

}


#pragma mark -
#pragma mark Table view data source

/*
 * Customize the number of sections in the table view.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
	// count it
    return 3;
}


/*
 * Customize the number of rows in the table view.
 */
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {

	 // section
    switch (section) {
		case SectionInfoRecommend: {
			return 1;
		}
		case SectionInfoApp: {
			return 2;
		}
		case SectionInfoFeedback: {
			return 1;
		}
    }
    
    return 0;
}



#pragma mark -
#pragma mark UITableViewDelegate Protocol


/*
 * Customize the appearance of table view cells.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	// identifiers
    static NSString *CellInfoIdentifier = @"CellInfo";
	static NSString *CellInfoButtonIdentifier = @"CellPreferencesButton";
	
	// create cell
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellInfoIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellInfoIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	// configure
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0]; 
	cell.textLabel.textColor = [UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0];
	
	
	// section
    NSUInteger section = [indexPath section];
    switch (section) {
			
		// info
        case SectionInfoApp: {
		
			// preferences
            if ([indexPath row] == AppCredits) {
				
				// cell
				cell.textLabel.text = NSLocalizedString(@"Credits",@"Credits");
				
				// accessory
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
			
			// preferences
            if ([indexPath row] == AppPreferences) {
				
				// cell
				cell.textLabel.text = NSLocalizedString(@"Preferences",@"Preferences");
				
				// accessory
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
			
			// have a break
			break; 
		}
		
		// recommend
		case SectionInfoRecommend: {
			
			// recommend
            if ([indexPath row] == RecommendApp) {
				
				// create cell
				CellButton *cbutton = (CellButton*) [tableView dequeueReusableCellWithIdentifier:CellInfoButtonIdentifier];
				if (cbutton == nil) {
					cbutton = [[[CellButton alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellInfoButtonIdentifier] autorelease];
				}				
				
				// prepare cell
				cbutton.delegate = self;
				cbutton.tag = InfoActionRecommend;
				[cbutton.buttonAccessory setTitle:NSLocalizedString(@"Recommend P5P",@"Recommend P5P") forState:UIControlStateNormal];
				[cbutton update:YES];
				
				// set cell
				cell = cbutton;

			}
			
			// break it
			break; 
		}
		
		// feedback
		case SectionInfoFeedback: {
			
			// reset user defaults
            if ([indexPath row] == FeedbackSend) {
				
				// create cell
				CellButton *cbutton = (CellButton*) [tableView dequeueReusableCellWithIdentifier:CellInfoButtonIdentifier];
				if (cbutton == nil) {
					cbutton = [[[CellButton alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellInfoButtonIdentifier] autorelease];
				}				
				
				// prepare cell
				cbutton.delegate = self;
				cbutton.tag = InfoActionFeedback;
				[cbutton.buttonAccessory setTitle:NSLocalizedString(@"Send Feedback",@"Send Feedback") forState:UIControlStateNormal];
				[cbutton update:YES];
				
				// set cell
				cell = cbutton;

			}
			
			// break it
			break; 
		}
	}
	
	
	// return
    return cell;
}


/*
 * Called when a table cell is selected.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	FLog();
	
	// section
    NSUInteger section = [indexPath section];
    switch (section) {	
			
		// app
        case SectionInfoApp: {
			// credits
            if ([indexPath row] == AppCredits) {
				
				// controller
			    CreditsViewController *creditsViewController = [[CreditsViewController alloc] initWithStyle:UITableViewStyleGrouped];
				
				// navigate 
				[self.navigationController pushViewController:creditsViewController animated:YES];
				[creditsViewController release];
			}
			
			// preferences
            if ([indexPath row] == AppPreferences) {
				
				// controller
			    PreferencesViewController *preferencesViewController = [[PreferencesViewController alloc] initWithStyle:UITableViewStyleGrouped];
				
				// navigate 
				[self.navigationController pushViewController:preferencesViewController animated:YES];
				[preferencesViewController release];
			}
			break;
			
		}
	}
	
}


#pragma mark -
#pragma mark Memory management

/**
* Deallocates all used memory.
*/
- (void)dealloc {
	GLog();
	
	// duper
    [super dealloc];
}

@end

