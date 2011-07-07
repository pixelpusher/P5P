//
//  PreferencesViewController.m
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

#import "PreferencesViewController.h"
#import "P5PAppDelegate.h"
#import "P5PConstants.h"
#import "Tracker.h"
#import "AccountTwitterViewController.h"


/*
* Helper Stack.
*/
@interface PreferencesViewController (Helpers)
- (void)resetPreferences;
- (void)updatePreference:(NSString*)key value:(NSObject*)value;
- (void)updatePreferenceBool:(NSString*)key value:(BOOL)b;
@end


/**
* Preferences Controller.
*/
@implementation PreferencesViewController

#pragma mark -
#pragma mark Constants

// constants
#define kKeyResetUserDefaults	@"key_reset_user_defaults"


#pragma mark -
#pragma mark Properties




#pragma mark -
#pragma mark View lifecycle

/*
* Loads the view.
*/
- (void)loadView {
	[super loadView];
	DLog();
	
	 // title
	self.navigationItem.title = [NSString stringWithFormat:@"%@", NSLocalizedString(@"Preferences",@"Preferences")];

	
	// remove background for iPhone
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.opaque = YES;
	self.tableView.backgroundView = nil;

}


/*
* Prepares the view.
*/
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	DLog();
	
	// track
	[Tracker trackPageView:[NSString stringWithFormat:@"/info/preferences"]];
}


#pragma mark -
#pragma mark Cell Delegates

/*
* CellButton.
*/
- (void)cellButtonTouched:(CellButton *)c {
	GLog();
	
	// reset
	if ([c.key isEqualToString:kKeyResetUserDefaults]) {
		// action sheet
		UIActionSheet *resetAction = [[UIActionSheet alloc]
								  initWithTitle:NSLocalizedString(@"Clear all defaults?",@"Clear all defaults?")
								  delegate:self
								  cancelButtonTitle:NSLocalizedString(@"Cancel",@"Cancel")
								  destructiveButtonTitle:NSLocalizedString(@"Reset",@"Reset")
								  otherButtonTitles:nil];
	
		// show
		[resetAction setTag:PreferencesActionReset];
		[resetAction showInView:self.navigationController.view];
		[resetAction release];
	}

}

/*
* CellSwitch.
*/
- (void)cellSwitchChanged:(CellSwitch *)c {
	GLog();
	
	// sound disable
	if ([c.key isEqualToString:udPreferenceSoundDisabled]) {
		[self updatePreferenceBool:udPreferenceSoundDisabled value:![c.switchAccessory isOn]];
	}
    
    // toolbar autohide
	if ([c.key isEqualToString:udPreferenceToolbarAutohideEnabled]) {
		[self updatePreferenceBool:udPreferenceToolbarAutohideEnabled value:[c.switchAccessory isOn]];
	}
    
    // refresh tap
	if ([c.key isEqualToString:udPreferenceRefreshTapEnabled]) {
		[self updatePreferenceBool:udPreferenceRefreshTapEnabled value:[c.switchAccessory isOn]];
	}

}

/*
* CellText.
*/
- (void)cellTextChanged:(CellText *)c {
	GLog();
	
	// update
	[self updatePreference:c.key value:c.text];

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
	
		// reset
		case PreferencesActionReset: {
			// reset
			if (buttonIndex == 0) {
				FLog("reset");
				[self resetPreferences];
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
 * Resets the preferences
 */
- (void)resetPreferences {
	FLog();
	
	// reset
	[(P5PAppDelegate*)[[UIApplication sharedApplication] delegate] resetUserDefaults];
		
	// update
	[self.tableView reloadData];
}

/*
 * Updates a preference.
 */
- (void)updatePreference:(NSString*)key value:(NSObject*)value {
	FLog();
		
	// user defaults
	[(P5PAppDelegate*)[[UIApplication sharedApplication] delegate] setUserDefault:key value:value];
		
	// update
	[self.tableView reloadData];
}
- (void)updatePreferenceBool:(NSString*)key value:(BOOL)b {
	FLog();
		
	// user defaults
	[(P5PAppDelegate*)[[UIApplication sharedApplication] delegate] setUserDefaultBool:key value:b];
		
	// update
	[self.tableView reloadData];
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
		case SectionPreferencesGeneral: {
			return 2;
		}
        case SectionPreferencesSketch: {
			return 2;
		}
        case SectionPreferencesAccounts: {
			return 1;
		}
		case SectionPreferencesReset: {
			return 1;
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
		case SectionPreferencesGeneral: {
			return NSLocalizedString(@"General",@"General");
		}
        case SectionPreferencesSketch: {
			return NSLocalizedString(@"Sketch",@"Sketch");
		}
        case SectionPreferencesAccounts: {
			return NSLocalizedString(@"Accounts",@"Accounts");
		}
		case SectionPreferencesReset: {
			return NSLocalizedString(@"Reset",@"Reset");
		}
    }
    
    return nil;
}


/*
 * Customize the appearance of table view cells.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	// identifiers
    static NSString *CellPreferencesIdentifier = @"CellPreferences";
	static NSString *CellPreferencesButtonIdentifier = @"CellPreferencesButton";
	static NSString *CellPreferencesSwitchIdentifier = @"CellPreferencesSwitch";
	static NSString *CellPreferencesTextIdentifier = @"CellPreferencesText";
	
	
	// cell
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellPreferencesIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellPreferencesIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	
	// section
    NSUInteger section = [indexPath section];
    switch (section) {
	
		// general
		case SectionPreferencesGeneral: {
		FLog("SectionPreferencesGeneral");
		
			// email
            if ([indexPath row] == PreferenceEmail) {
				
				// create cell
				CellText *ctext = (CellText*) [tableView dequeueReusableCellWithIdentifier:CellPreferencesTextIdentifier];
				if (ctext == nil) {
					ctext = [[[CellText alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellPreferencesTextIdentifier] autorelease];
				}	
				
				// prepare cell
				ctext.delegate = self;
				ctext.key = udPreferenceEmail;
				ctext.text = (NSString*) [(P5PAppDelegate*)[[UIApplication sharedApplication] delegate] getUserDefault:udPreferenceEmail];
				ctext.placeholder = NSLocalizedString(@"Default Email Address",@"Default Email Address");
				ctext.textLabel.text = NSLocalizedString(@"Email",@"Email");
				[ctext update:YES];
				
				// set cell
				cell = ctext;

			}
            
            // sound
            if ([indexPath row] == PreferenceSoundDisabled) {
				
				// create cell
				CellSwitch *cswitch = (CellSwitch*) [tableView dequeueReusableCellWithIdentifier:CellPreferencesSwitchIdentifier];
				if (cswitch == nil) {
					cswitch = [[[CellSwitch alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellPreferencesSwitchIdentifier] autorelease];
				}	
				
				// enabled
				BOOL disabled = [(P5PAppDelegate*)[[UIApplication sharedApplication] delegate] getUserDefaultBool:udPreferenceSoundDisabled];
				
				// prepare cell
				cswitch.delegate = self;
				cswitch.key = udPreferenceSoundDisabled;
				cswitch.textLabel.text = NSLocalizedString(@"Sound",@"Sound");
				cswitch.switchAccessory.on = !(disabled);
				[cswitch update:YES];
				
				// set cell
				cell = cswitch;
                
			}
			
			
			// break it
			break; 
		}
            
            
        // sketch
		case SectionPreferencesSketch: {
            FLog("SectionPreferencesSketch");
			
			// toolbar autohide
            if ([indexPath row] == PreferenceToolbarAutohide) {
				
				// create cell
				CellSwitch *cswitch = (CellSwitch*) [tableView dequeueReusableCellWithIdentifier:CellPreferencesSwitchIdentifier];
				if (cswitch == nil) {
					cswitch = [[[CellSwitch alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellPreferencesSwitchIdentifier] autorelease];
				}	
				
				// enabled
				BOOL enabled = [(P5PAppDelegate*)[[UIApplication sharedApplication] delegate] getUserDefaultBool:udPreferenceToolbarAutohideEnabled];
				
				// prepare cell
				cswitch.delegate = self;
				cswitch.key = udPreferenceToolbarAutohideEnabled;
				cswitch.textLabel.text = NSLocalizedString(@"Autohide Toolbar",@"Autohide Toolbar");
				cswitch.switchAccessory.on = enabled;
				[cswitch update:YES];
				
				// set cell
				cell = cswitch;
                
			}
            
            // reload tap
            if ([indexPath row] == PreferenceRefreshTap) {
				
				// create cell
				CellSwitch *cswitch = (CellSwitch*) [tableView dequeueReusableCellWithIdentifier:CellPreferencesSwitchIdentifier];
				if (cswitch == nil) {
					cswitch = [[[CellSwitch alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellPreferencesSwitchIdentifier] autorelease];
				}	
				
				// enabled
				BOOL enabled = [(P5PAppDelegate*)[[UIApplication sharedApplication] delegate] getUserDefaultBool:udPreferenceRefreshTapEnabled];
				
				// prepare cell
				cswitch.delegate = self;
				cswitch.key = udPreferenceRefreshTapEnabled;
				cswitch.textLabel.text = NSLocalizedString(@"DoubleTap Refresh",@"DoubleTap Refresh");
				cswitch.switchAccessory.on = enabled;
				[cswitch update:YES];
				
				// set cell
				cell = cswitch;
                
			}
			
			
			// break it
			break; 
		}
		
		// general
		case SectionPreferencesAccounts: {
		FLog("SectionPreferencesAccounts");
			
			// sound
            if ([indexPath row] == AccountTwitter) {
				
				// prepare cell
				cell.textLabel.text = NSLocalizedString(@"Twitter",@"Twitter");
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				
			}
			
			// kitty kat
			break;
		}
	
		// reset
		case SectionPreferencesReset: {
		FLog("SectionPreferencesReset");
			
			// reset user defaults
            if ([indexPath row] == ResetUserDefaults) {
				
				// create cell
				CellButton *cbutton = (CellButton*) [tableView dequeueReusableCellWithIdentifier:CellPreferencesButtonIdentifier];
				if (cbutton == nil) {
					cbutton = [[[CellButton alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellPreferencesButtonIdentifier] autorelease];
				}				
				
				// prepare cell
				cbutton.delegate = self;
				cbutton.key = kKeyResetUserDefaults;
				[cbutton.buttonAccessory setTitle:NSLocalizedString(@"Reset Defaults",@"Reset Defaults") forState:UIControlStateNormal];
				[cbutton update:YES];
				
				// set cell
				cell = cbutton;

			}
			
			// break it
			break; 
		}
	}
	
	// configure
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0]; 
	cell.textLabel.textColor = [UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0];
	
	// return
    return cell;
}




#pragma mark -
#pragma mark UITableViewDelegate Protocol

/*
 * Called when a table cell is selected.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	FLog();
	
	// section
    NSUInteger section = [indexPath section];
    switch (section) {
	
		// general
		case SectionPreferencesGeneral: {
		
			// email
            if ([indexPath row] == PreferenceEmail) {
			
				// cell
				CellText *ctext = (CellText*) [tableView cellForRowAtIndexPath:indexPath];
		
				// push controller
				CellTextViewController *tvController = [ctext textViewController:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
				tvController.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
				tvController.textField.keyboardType = UIKeyboardTypeEmailAddress;
				[self.navigationController pushViewController:tvController animated:YES];
				[tvController release];
			}
			break;
		}
		
		// accounts
		case SectionPreferencesAccounts: {
		
			// twitter
            if ([indexPath row] == AccountTwitter) {

		
				// push controller
				AccountTwitterViewController *accountTwitterController = [[AccountTwitterViewController alloc] initWithStyle:UITableViewStyleGrouped];
				[self.navigationController pushViewController:accountTwitterController animated:YES];
				[accountTwitterController release];
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

