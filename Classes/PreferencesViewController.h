//
//  PreferencesViewController.h
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
