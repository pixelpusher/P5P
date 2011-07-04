//
//  PreferencesViewController.h
//  P5P
//
//  Created by CNPP on 17.2.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellButton.h"
#import "CellSwitch.h"
#import "CellText.h"

// actions
enum {
    PreferencesActionReset
} PreferencesActions;

//  Sections
enum {
    SectionPreferencesGeneral,
    SectionPreferencesSketch,
	SectionPreferencesAccounts,
	SectionPreferencesReset
} P5PPreferencesSections;

//  General Fields
enum {
	PreferenceEmail,
	PreferenceSoundDisabled
} P5PPreferencesSectionGeneral;

//  Sketch Fields
enum {
    PreferenceToolbarAutohide,
    PreferenceRefreshTap
} P5PPreferencesSectionSketch;

//  Account Fields
enum {
	AccountTwitter
} P5PPreferencesSectionAccounts;

//  Reset Fields
enum {
	ResetUserDefaults
} P5PPreferencesSectionReset;

/**
* Preferences Controller.
*/
@interface PreferencesViewController : UITableViewController <UIActionSheetDelegate, CellButtonDelegate, CellSwitchDelegate, CellTextDelegate> {

}

@end
