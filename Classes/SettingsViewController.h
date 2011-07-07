//
//  SettingsViewController.h
//  P5P
//
//  Created by CNPP on 10.2.2011.
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
#import "JSON/JSON.h"
#import "CellSwitch.h"
#import "CellSlider.h"
#import "CellRange.h"
#import "CellPicker.h"
#import "CellColor.h"


/*
* Delegate.
*/
@protocol SettingsDelegate <NSObject>
- (void)settingsApply;
- (void)settingsUpdate;
- (void)settingsReset;
- (NSString*)settingsKey;
- (NSSet*)settingsSketch;
@end


/**
 * GroupData.
 */
@interface GroupData : NSObject {

}

// Properties
@property (nonatomic, retain) NSString *section;
@property (nonatomic, retain) NSMutableArray *data;

@end


/**
 * SettingData.
 */
@interface SettingData : NSObject {

}

// Properties
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSNumber * sort;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * live;
@property (nonatomic, retain) NSString * options;

@end


/**
* SettingsViewController.
*/
@interface SettingsViewController : UITableViewController <CellSwitchDelegate, CellSliderDelegate, CellRangeDelegate, CellPickerDelegate, CellColorDelegate> {

	// delegate
	id<SettingsDelegate>delegate;
	
	// data
	NSMutableArray *settings;
	NSMutableDictionary *defaults;
	
	// modes
	BOOL modeModal;
	
	// tags
	@private
	NSMutableDictionary *tags;
}

// Properties
@property (assign) id<SettingsDelegate> delegate;
@property (nonatomic,retain) NSMutableArray *settings;
@property (nonatomic,retain) NSMutableDictionary *defaults;
@property BOOL modeModal;

// Helpers
- (void)reloadSettings;
- (void)updateSetting:(NSString*)key value:(NSString*)v;
- (void)updateLiveSetting:(NSString*)key value:(NSString*)v;

// Actions
- (void)actionReset:(id)sender;
- (void)actionApply:(id)sender;

@end
