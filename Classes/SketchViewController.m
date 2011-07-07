//
//  SketchViewController.m
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

#import "SketchViewController.h"
#import "P5PAppDelegate.h"
#import "P5PConstants.h"
#import "Collection.h"
#import "Sketch.h"
#import "SettingGroup.h"
#import "Setting.h"
#import "Default.h"
#import "Tracker.h"



/*
* Helper Stack.
*/
@interface SketchViewController (Helpers)
- (void)exportSave:(id)sender;
- (void)exportPrint:(id)sender;
- (void)exportEmail:(id)sender;
- (void)exportTwitter:(id)sender;
@end
@interface SketchViewController (AnimationHelpers)
- (void)animationShowHideToolbarDone;
@end




/**
* SketchViewController.
*/
@implementation SketchViewController


#pragma mark -
#pragma mark Constants

// constants
#define kToolbarOpacity	0.96f
#define kToolbarTimeShow 0.21f
#define kToolbarTimeHide 0.45f
#define kToolbarAutohideTime 20.0f


#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;
@synthesize sketch;
@synthesize modeModal;



#pragma mark -
#pragma mark Object Methods

/**
* Init.
*/
- (id)init {
	
	// init super
	if ((self = [super init])) {
		GLog();
	
		// field defaults
		self.modeModal = NO;
        modeRefreshTap = NO;
        modeToolbarAnimating = NO;
		
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
	
	// room with a view
	UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	

	// toolbar
	SketchToolbar *tb = [[SketchToolbar alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 44)];
	tb.alpha = kToolbarOpacity;
	[tb setAutoresizingMask: (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight) ];
	
	
	
	// label
	UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tb.frame.size.width/3.0, tb.frame.size.height)];
	[lbl setText:@"P5P"];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]];
    //[lbl setShadowColor:[UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.95]];
    //[lbl setShadowOffset:CGSizeMake(1,1)];
	
	// make it big
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		[lbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
		[lbl setTextAlignment:UITextAlignmentCenter];
	}
	else {
		[lbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
		[lbl setTextAlignment:UITextAlignmentLeft];
	}

	
	labelTitle = [lbl retain];
	[lbl release];

	
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
	spacer.width = 10;
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
		spacer.width = 0;
	}
	
	// inset
	UIBarButtonItem *inset = [[UIBarButtonItem alloc] 
								   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace 
								   target:self
								   action:nil];
	inset.width = 5;
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
		inset.width = 0;
	}
	

	// button back
	UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
								initWithImage:[UIImage imageNamed:@"btn_back.png"]  
								style:UIBarButtonItemStyleBordered
								target:self
								action:@selector(actionBack:)];
								
	// button title
	UIBarButtonItem *btnTitle = [[UIBarButtonItem alloc] initWithCustomView:labelTitle];
								
	// button settings
	UIBarButtonItem *btnSettings = [[UIBarButtonItem alloc] 
								  initWithImage:[UIImage imageNamed:@"btn_settings.png"] 
								  style:UIBarButtonItemStylePlain
								  target:self 
								  action:@selector(actionSettings:)];
								  
	// button export
	UIBarButtonItem *btnExport = [[UIBarButtonItem alloc] 
								  initWithImage:[UIImage imageNamed:@"btn_export.png"]
								  style:UIBarButtonItemStylePlain  
								  target:self 
								  action:@selector(actionExport:)];
								
	
	// button refresh
	UIBarButtonItem *btnRefresh = [[UIBarButtonItem alloc] 
								  initWithImage:[UIImage imageNamed:@"btn_refresh.png"]
								  style:UIBarButtonItemStylePlain  
								  target:self 
								  action:@selector(actionRefresh:)];
	
								  
								  
	// buttons
	NSArray *buttons = [NSArray arrayWithObjects: 
							inset,
							btnBack,
							flex,
							btnTitle,
							flex,
							btnSettings,
							spacer,
							btnExport,
							spacer,
							btnRefresh,
							inset,
							nil];
	[flex release];
	[spacer release];
	[inset release];
	[btnTitle release];
	[btnBack release];
	[btnSettings release];
	[btnExport release];
	[btnRefresh release];

	// add array of buttons to toolbar
	[tb setItems:buttons animated:NO];
	
	// set and add to view
	toolbar = [tb retain];
	[view addSubview:toolbar];
	[tb release];
	
	// settings view
	SettingsViewController *svController = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
	svController.delegate = self;
	svController.view.frame = CGRectMake(0, 0, 320, 480);
	[svController.view setAutoresizingMask: (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight) ];
	settingsViewController = [svController retain];
	
	
	// html view
	HTMLView *hv = [[HTMLView alloc] initWithFrame:view.frame scrolling:NO];
	hv.delegate = self;
	[hv setAutoresizingMask: (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight) ];
	
	// set and add to view 
	htmlView = [hv retain];
	[view addSubview:htmlView];
	[view sendSubviewToBack:htmlView];
	[hv release];
	
	// note view
	NoteView *nv = [[NoteView alloc] initWithFrame:view.frame];
	[nv setAutoresizingMask: (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight) ];
	
	// set and add to view 
	note = [nv retain];
	[view addSubview:note];
	[view bringSubviewToFront:note];
	[nv release];
	
	// tap detecting window
	tapWindow = (TapDetectingWindow *)[[UIApplication sharedApplication].windows objectAtIndex:0];
    tapWindow.viewToObserve = htmlView;
    tapWindow.controllerThatObserves = self;

	
	// good to go
	self.view = view;
}



/*
* Prepares the view.
*/
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	DLog();
	
	// exclude modal
	if (! modeModal) {
	
		// track
		[Tracker trackPageView:[NSString stringWithFormat:@"/sketch/%@/%@",sketch.collection.cid,sketch.sid]];
	
		// update title
		[labelTitle setText:sketch.name];
		
		// update settings button
		BOOL se = NO;
		if ([sketch.settingGroups count] > 0) {
			se = YES;
		}
		UIBarButtonItem *btnSettings = [toolbar.items objectAtIndex:5];
		btnSettings.enabled = se;
		

		// reload sketch
		[self reloadSketch];
	
		// indicate toolbar
		[self showToolbar];
		if ([(P5PAppDelegate*)[[UIApplication sharedApplication] delegate] getUserDefaultBool:udPreferenceToolbarAutohideEnabled]) {
			[self performSelector:@selector(fadeoutToolbar) withObject:nil afterDelay:kToolbarAutohideTime];
		}
        
        // show sketch notification
        NSString *sketchNotification = (NSString*) [(P5PAppDelegate*)[[UIApplication sharedApplication] delegate] retrieveNotification:udNoteSketch];
        if (sketchNotification) {
            [note notificationInfo:sketchNotification];
            [note showNotificationAfterDelay:1.5];
        }
	
	}
    
    // mode refresh
    modeRefreshTap = [(P5PAppDelegate*)[[UIApplication sharedApplication] delegate] getUserDefaultBool:udPreferenceRefreshTapEnabled];

	
}

/*
* Resets the view.
*/
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	FLog();
	
	// exclude modal
	if (! modeModal) {
        
		// unload
		[self unloadSketch];
	
		// hide export
		if (exportActionSheet != NULL) {
			[exportActionSheet dismissWithClickedButtonIndex:-1 animated:YES];
			exportActionSheet = nil;
		}
        
	}
	
}


/*
* Cleanup.
*/
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	FLog();
	
	// exclude modal
	if (! modeModal) {
		// release sketch
		[sketch release];
		sketch = nil;
	}
}




/*
* Toolbar flag.
*/
static BOOL toolbarHidden = NO;

/*
* Show/Hide toolbar.
*/
- (void)showHideToolbar:(BOOL)animated {
	GLog();
    
    // check
    if (modeToolbarAnimating) {
        return;
    }
	
	
	// time
	float at = 0;
	if (animated && toolbarHidden) {
		at = kToolbarTimeShow;
	}
	else if (animated && ! toolbarHidden) {
		at = kToolbarTimeHide;
	}
	
	// animate toolbar
    modeToolbarAnimating = YES;
	[UIView beginAnimations:@"toolbar" context:nil];
	[UIView setAnimationDuration:at];
	if (toolbarHidden) {
		toolbar.frame = CGRectOffset(toolbar.frame, 0, toolbar.frame.size.height);
		toolbar.alpha = kToolbarOpacity;
	} 
	else {
		toolbar.frame = CGRectOffset(toolbar.frame, 0, -toolbar.frame.size.height);
		toolbar.alpha = 0;
	}
	[UIView commitAnimations];
    
    // clean up
	[self performSelector:@selector(animationShowHideToolbarDone) withObject:nil afterDelay:at];
	

}
- (void)animationShowHideToolbarDone {
    GLog();
    
    // toggle flag
	toolbarHidden = ! toolbarHidden;
    
    // leave mode
    modeToolbarAnimating = NO;
}

/*
* Hides the toolbar.
*/
- (void)fadeoutToolbar {
	GLog();
	
	// check
	if (! toolbarHidden && ! modeToolbarAnimating) {
		[self showHideToolbar:YES];
	}
}

/*
* Shows the toolbar.
*/
- (void)showToolbar {
	GLog();
	
	// set
	toolbarHidden = NO;
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeoutToolbar) object:nil];
	toolbar.frame = CGRectMake(0,0,toolbar.frame.size.width, toolbar.frame.size.height);
	toolbar.alpha = kToolbarOpacity;

}




#pragma mark -
#pragma mark Business Methods

/*
* Loads the sketch.
*/
- (void)loadSketch {
	DLog();
        
	// reload
	[htmlView loadPage:@"sketches/sketch.html"];
}

/*
* Reloads the sketch.
*/
- (void)reloadSketch {
	DLog();
        
	// reload
	[htmlView reloadPage];
}

/*
* Unloads the sketch.
*/
- (void)unloadSketch {
	DLog();
        
	// reload
	[htmlView unloadPage];
}



#pragma mark -
#pragma mark TapDetectingWindow


/*
* Single tap handler.
*/
-(void)singleTap:(id)tapPoint {
	GLog();

}

/*
* Double tap handler.
*/
-(void)doubleTap:(id)tapPoint {
	FLog();
	
	// top
	float top = self.view.frame.size.height / 4.0;
	
	// hide & seek
	NSArray *p = (NSArray*) tapPoint;
	NSNumber *py = [p objectAtIndex:1];
	if ([py floatValue] < top) {
		[self showHideToolbar:YES];
	}
	else if (modeRefreshTap) {
        
		// track
		[Tracker trackEvent:TEventSketch action:@"Refresh" label:[NSString stringWithFormat:@"/%@/%@",sketch.collection.cid,sketch.sid]];
	
		// tha fresh prince
		[htmlView refreshPage];
	}


}





#pragma mark -
#pragma mark Actions


/*
* Back to the future.
*/
- (void)actionBack:(id)sender {
	DLog();
	
	// show toolbar
	[self showToolbar];
	
	// delegate
	if (delegate != NULL && [delegate respondsToSelector:@selector(navigateToRoot)]) {
		[delegate navigateToRoot];
	}
}


/*
* Settings.
*/
- (void)actionSettings:(id)sender {
	DLog();
	
	// track
	[Tracker trackEvent:TEventSketch action:@"Settings" label:[NSString stringWithFormat:@"/%@/%@",sketch.collection.cid,sketch.sid]];
	
	// show toolbar
	[self showToolbar];
	
	// hide export
	if (exportActionSheet != NULL) {
		[exportActionSheet dismissWithClickedButtonIndex:-1 animated:NO];
		exportActionSheet = nil;
	}
}

/*
* Settings.
*/
- (void)actionExport:(id)sender {
	DLog();
	
	// track
	[Tracker trackEvent:TEventSketch action:@"Export" label:[NSString stringWithFormat:@"/%@/%@",sketch.collection.cid,sketch.sid]];
	
	// show toolbar
	[self showToolbar];
	
	// dismiss popover if already visible
	if (exportActionSheet != nil) {
		[exportActionSheet dismissWithClickedButtonIndex:-1 animated:YES];
		exportActionSheet = nil;
		return;
	}
	
	// export options
	NSMutableArray *exportOptions = [[NSMutableArray alloc] init];
	[exportOptions addObject:NSLocalizedString(@"Save",@"Save")];
	if ([UIPrintInteractionController isPrintingAvailable]) {
		[exportOptions addObject:NSLocalizedString(@"Print",@"Print")];
	}
	if ([MFMailComposeViewController canSendMail]) {
		[exportOptions addObject:NSLocalizedString(@"Email",@"Email")];
	}
	[exportOptions addObject:NSLocalizedString(@"Twitter",@"Twitter")];
	
	
	// action sheet
	exportActionSheet = [[UIActionSheet alloc]
								 initWithTitle:nil
								 delegate:self
								 cancelButtonTitle:nil
                                 destructiveButtonTitle:nil
                                 otherButtonTitles:nil];
	
	// options
	for (NSString *o in exportOptions) {
		[exportActionSheet addButtonWithTitle:o];
	}
	exportActionSheet.cancelButtonIndex=[exportOptions count];
	[exportActionSheet addButtonWithTitle:NSLocalizedString(@"Cancel",@"Cancel")];
	[exportOptions release];
	
	// action time
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		[exportActionSheet showFromBarButtonItem:sender animated:YES];
	}
	else {
		[exportActionSheet showInView:self.view];
	}
}

/*
* Refresh.
*/
- (void)actionRefresh:(id)sender {
	DLog();
	
	// track
	[Tracker trackEvent:TEventSketch action:@"Refresh" label:[NSString stringWithFormat:@"/%@/%@",sketch.collection.cid,sketch.sid]];
	
	// show toolbar
	[self showToolbar];
	
	// fresh
	[htmlView refreshPage];
}


#pragma mark -
#pragma mark Export Actions

/*
* Save.
*/
- (void)exportSave:(id)sender {
	DLog();
	
	// track
	[Tracker trackEvent:TEventExport action:@"Save" label:[NSString stringWithFormat:@"/%@/%@",sketch.collection.cid,sketch.sid]];
	
	
	// note
	[note noteActivity:@"Capture Screenshot..."];
	[note showNote];
	
	// screenshot
	UIImage *screenshot = [htmlView screenshot];
	
	// save image
	UIImageWriteToSavedPhotosAlbum(screenshot, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
	GLog();
 
	// Unable to save the image  
	if (error) {
		UIAlertView *alert;
		alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                            message:@"Unable to save image to Photo Album." 
                            delegate:self cancelButtonTitle:@"Ok" 
                            otherButtonTitles:nil];
		[alert setTag:P5PSketchCaptureError];
		[alert show];
		[alert release];
	}
	// all is well
	else {
		[note noteSuccess:@"Image saved to Photo Album."];
	}
	
	// dismiss
	[note dismissNote];
	
}

/*
* Print.
*/
- (void)exportPrint:(id)sender {
	DLog();
	
	// track
	[Tracker trackEvent:TEventExport action:@"Print" label:[NSString stringWithFormat:@"/%@/%@",sketch.collection.cid,sketch.sid]];
	
	// check availability
	if (! [UIPrintInteractionController isPrintingAvailable]) {
			
		// note
		[note noteError:@"Printing not supported." ];
		[note showNote];
		[note dismissNoteAfterDelay:2.4];
	}
	else {
	
		// note
		[note noteActivity:@"Capture Screenshot..."];
		[note showNote];
	
		// screenshot
		UIImage *screenshot = [htmlView screenshot];
		
		// print controller
		UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
        pic.delegate = self;
		
		// print info
		UIPrintInfo *printInfo = [UIPrintInfo printInfo];
		printInfo.outputType = UIPrintInfoOutputGeneral;
		printInfo.jobName = [NSString stringWithFormat:@"P5P %@",sketch.name];
		printInfo.orientation = UIPrintInfoOrientationPortrait;
		pic.printInfo = printInfo;
		pic.showsPageRange = NO;
		pic.printingItem = screenshot;
		
		// handler
		void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
		^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
			
			// error
			if (!completed && error) {
				UIAlertView *alert = [[UIAlertView alloc]
									  initWithTitle:@"Print Error" 
									  message:[NSString stringWithFormat:@"Printing could not complete because of error: %@", error]
									  delegate:nil 
									  cancelButtonTitle: @"OK"
									  otherButtonTitles:nil];
				[alert setTag:P5PSketchPrintError];
				[alert show];    
				[alert release];
			}
			
			// completed
			else if	(completed) {
				[note noteSuccess:@"Printing completed."];
				[note showNote];
				[note dismissNote];
			}
		};
		

		// the show must go on
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			[pic presentFromBarButtonItem:sender animated:YES completionHandler:completionHandler];
		} else {
			[pic presentAnimated:YES completionHandler:completionHandler];
		}
		
		// dismiss
		[note dismissNote];

	}

}

/*
* Email.
*/
- (void)exportEmail:(id)sender {
	DLog();
	
	// track
	[Tracker trackEvent:TEventExport action:@"Email" label:[NSString stringWithFormat:@"/%@/%@",sketch.collection.cid,sketch.sid]];
	
	// check mail support
	if (! [MFMailComposeViewController canSendMail]) {

		// note
		[note noteError:@"Email not configured." ];
		[note showNote];
		[note dismissNoteAfterDelay:2.4];

	}
	else {
	
		// date formatter
		static NSDateFormatter *exportDateFormatter = nil;
		if (exportDateFormatter == nil) {
			exportDateFormatter = [[NSDateFormatter alloc] init];
			[exportDateFormatter setDateFormat:@"yyyyMMdd-HHmm"];
		}
	
		// screenshot
		UIImage *screenshot = [htmlView screenshot];
		
		// modal mode
		[self setModeModal:YES]; // avoids unload in case view is hidden
		
		// mail composer
		MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
		composer.mailComposeDelegate = self;
        composer.navigationBar.barStyle = UIBarStyleBlack;
		
		// recipient
		NSString *email = (NSString*) [(P5PAppDelegate*)[[UIApplication sharedApplication] delegate] getUserDefault:udPreferenceEmail];
		if (email) {
			[composer setToRecipients:[[[NSArray alloc] initWithObjects:email,nil] autorelease]];
		}
		
		// subject
		[composer setSubject:[NSString stringWithFormat:@"[P5P] %@",sketch.name]];
	 
		// message
		NSString *message = @"\n\n\n---\nGenerated with P5P.\nhttp://p5p.cecinestpasparis.net";
		[composer setMessageBody:message isHTML:NO];
	 
		// attachment
		NSData *data = UIImagePNGRepresentation(screenshot);
		[composer addAttachmentData:data mimeType:@"image/png" 
					fileName:[NSString stringWithFormat:@"p5p_%@_%@",sketch.sid,[exportDateFormatter stringFromDate:[NSDate date]]]];
	 
		// show off
		[self presentModalViewController:composer animated:YES];
	 
		// release
		[composer release];
		
	}
}

/*
* Twitter.
*/
- (void)exportTwitter:(id)sender {
	DLog();
	
	// track
	[Tracker trackEvent:TEventExport action:@"Twitter" label:[NSString stringWithFormat:@"/%@/%@",sketch.collection.cid,sketch.sid]];
	
	// screenshot
	UIImage *screenshot = [htmlView screenshot];
	
	// modal mode
	[self setModeModal:YES]; // avoids unload in case view is hidden
	
	// frame
	CGRect tframe = CGRectMake(0,0,540,620);
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
		tframe = CGRectMake(0,0,320,480);
	}
	

	// twitter compose
	TwitterComposeViewController *twitterCompose = [[TwitterComposeViewController alloc] initWithFrame:tframe];
	twitterCompose.delegate = self;
	
	// tweet
	[twitterCompose setStatusText:[NSString stringWithFormat:@"#P5P #%@",sketch.sid]];
	[twitterCompose setStatusImage:screenshot message:NSLocalizedString(@"Generated with P5P. \nhttp://p5p.cecinestpasparis.net",@"Generated with P5P. \nhttp://p5p.cecinestpasparis.net")];
	
	
	// navigation controller
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:twitterCompose];
	navController.view.backgroundColor = [UIColor colorWithRed:219.0/255.0 green:222.0/255.0 blue:227.0/255.0 alpha:1.0];
    navController.navigationBar.barStyle = UIBarStyleBlack;

 
	// ipad
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		navController.modalPresentationStyle = UIModalPresentationFormSheet;
		[navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
	}

	
	// show the navigation controller modally
	[self presentModalViewController:navController animated:YES];
 
	// clean up resources
	[navController release];
	[twitterCompose release];
	
}




#pragma mark -
#pragma mark HTMLDelegate

/*
 * Page properties.
 */
- (NSDictionary*)pageProperties {
	FLog();
	
	// page
    NSMutableDictionary *pageProps = [NSMutableDictionary dictionaryWithCapacity:4];
	
	// we have sketch
	if (sketch) {
		[pageProps setObject:[NSString stringWithFormat:@"P5P %@",sketch.name] forKey:@"title"];
		[pageProps setObject:sketch.sketch forKey:@"sketch"];
		[pageProps setObject:sketch.collection.lib forKey:@"lib"];
	}
	
	// return dict
    NSDictionary *pageReturn = [NSDictionary dictionaryWithDictionary:pageProps];
    return pageReturn;
}

/*
 * User defaults.
 */
- (NSDictionary*)userDefaults {
	FLog();

	// return dict
    NSMutableDictionary *defaultsReturn = [[[NSMutableDictionary alloc] init] autorelease];
	
	// add static defaults
	for (Default *d in sketch.defaults) {
		[defaultsReturn setValue:d.value forKey:d.key];
	}
	
	// add default settings
	for (SettingGroup *g in sketch.settingGroups) {
		for (Setting *s in g.settings) {
			[defaultsReturn setValue:s.value forKey:s.key];
		}
	}
	
	// add user defaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSDictionary *sketchDefaults = [[[userDefaults  dictionaryForKey:[self settingsKey]] mutableCopy] autorelease];
	[defaultsReturn addEntriesFromDictionary:sketchDefaults];
	
	// return
    return defaultsReturn;
}

/*
* Page loaded.
*/
- (void)pageLoaded {
	FLog();
	
	// loaded
	if (delegate != nil && [delegate respondsToSelector:@selector(preloaded)]) {
		[delegate preloaded];
	}
	
}


#pragma mark -
#pragma mark SettingDelegate

/*
 * Settings apply.
 */
- (void)settingsApply {
	FLog();
	
	// track
	[Tracker trackEvent:TEventSettings action:@"Apply" label:[NSString stringWithFormat:@"/%@/%@",sketch.collection.cid,sketch.sid]];
	
	// fresh
	[htmlView refreshPage];
}

/*
 * Settings reset.
 */
- (void)settingsReset {
	FLog();
	
	// track
	[Tracker trackEvent:TEventSettings action:@"Reset" label:[NSString stringWithFormat:@"/%@/%@",sketch.collection.cid,sketch.sid]];
	
	// fresh
	//[htmlView refreshPage];
}

/*
 * Settings update.
 */
- (void)settingsUpdate {
	GLog();
	
	// refresh
	[htmlView updatePage];
}


/*
 * Settings key.
 */
- (NSString*)settingsKey {
	GLog();
	
	// return key
	return [NSString stringWithFormat:@"%@_%@_%@", udSketchSettings, sketch.collection.cid,sketch.sid];
}

/*
 * Settings sketch.
 */
- (NSSet*)settingsSketch {
	GLog();
	
	// return key
	return sketch.settingGroups;
}



#pragma mark -
#pragma mark UIActionSheet Delegate



/*
 * Action selected.
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	FLog();
	
	// sender
	UIBarButtonItem *exportButton = [toolbar.items objectAtIndex:7];
	
	// readjust index
	if (! [UIPrintInteractionController isPrintingAvailable] && buttonIndex > 0) {
		buttonIndex++;
	}
	if (! [MFMailComposeViewController canSendMail] && buttonIndex > 0) {
		buttonIndex++;
	}
	
	
	// save
    if (buttonIndex == 0) {
		[self exportSave:exportButton];
    }
	// print
    else if (buttonIndex == 1) {
		[self exportPrint:exportButton];
    } 
	// email
	else if (buttonIndex == 2) {
		[self exportEmail:exportButton];
    }
	// twitter
	else if (buttonIndex == 3) {
		[self exportTwitter:exportButton];
    }
	
	// release
	if (exportActionSheet != NULL) {
		[exportActionSheet release];
		exportActionSheet = NULL;
	}

}


#pragma mark -
#pragma mark UIAlertViewDelegate Delegate


/*
 * Alert view button clicked.
 */
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	FLog();
	
	// determine alert
	switch ([actionSheet tag]) {

		// have a break
		default:
		break;
	}
	
	
}

#pragma mark -
#pragma mark TwitterComposeDelegate Protocol

/*
 * Dismisses the twitter composition interface when users tap Cancel or Send.
 */
- (void)dismissTwitterCompose {
	DLog();
	
	// dismiss modal
	[self dismissModalViewControllerAnimated:YES];
	
	// leave modal mode
	[self setModeModal:NO]; 
	
}


#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate Protocol

/*
 * Dismisses the email composition interface when users tap Cancel or Send.
 */
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {	
	FLog();
	
	// whatsup doc?
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
	
	// leave modal mode
	[self setModeModal:NO]; 
}



#pragma mark -
#pragma mark Memory management


/*
* Deallocates all used memory.
*/
- (void)dealloc {
	GLog();
	
	// release
	[toolbar release];
	[labelTitle release];
    [htmlView release];
	[settingsViewController release];
	
	// super
    [super dealloc];
}


@end
