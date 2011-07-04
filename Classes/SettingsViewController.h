//
//  SettingsViewController.h
//  P5P
//
//  Created by CNPP on 10.2.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

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
