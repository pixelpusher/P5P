//
//  SettingsViewController.m
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

#import "SettingsViewController.h"
#import "P5PConstants.h"
#import "SettingGroup.h"
#import "Setting.h"
#import "Tracker.h"


/**
* SettingsViewController.
*/
@implementation SettingsViewController


#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;
@synthesize settings;
@synthesize defaults;
@synthesize modeModal;


#pragma mark -
#pragma mark View lifecycle

/*
* Loads the view.
*/
- (void)loadView {
	[super loadView];
	DLog();

    // title
	self.navigationItem.title = NSLocalizedString(@"Settings",@"Settings");
	
	
	// button reset
	UIBarButtonItem *btnReset = [[UIBarButtonItem alloc] 
										initWithTitle:NSLocalizedString(@"Reset",@"Reset")
										style:UIBarButtonItemStyleBordered 
										target:self 
										action:@selector(actionReset:)];
	
	// button apply
	UIBarButtonItem *btnApply = [[UIBarButtonItem alloc] 
										initWithTitle:NSLocalizedString(@"Apply",@"Apply")
										style:UIBarButtonItemStyleBordered 
										target:self 
										action:@selector(actionApply:)];
	
    // remove background
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.opaque = YES;
    self.tableView.backgroundView = nil;
	
	// iPad
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        // pattern view
        UIView *pattern = [[UIView alloc] initWithFrame:self.view.frame];
        pattern.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_texture.png"]];
        self.tableView.backgroundView = pattern;
        
        // buttons
		self.navigationItem.leftBarButtonItem = btnReset;
		[btnReset release];	
		self.navigationItem.rightBarButtonItem = btnApply;
		[btnApply release];	

	}
	// iPhone
	else {
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
		spacer.width = 5;
		
								   
		// toolbar
		self.toolbarItems = [NSArray arrayWithObjects:
							spacer,
							btnReset,
							flex,
							btnApply,
							spacer,
							nil];
							
	}

}

/*
* Prepares the view.
*/
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	DLog();
	
	// size
	self.contentSizeForViewInPopover = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
	
	
	// reload table view
	if (modeModal) {
		[self.tableView reloadData];
	}
	// reload data
	else {
		// tags
		if (tags != nil) {
			[tags release];
		}
		tags = [[NSMutableDictionary alloc] init];
	
		// reload
		[self reloadSettings];
		
	}


	
	// nop
	[self setModeModal:NO];

}

#pragma mark -
#pragma mark Helpers

/*
* Reloads the data.
*/
- (void)reloadSettings {
	FLog();
    
    // pop
    [self.navigationController popToRootViewControllerAnimated:NO];
	
	// preferences
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	// create empty sketch settings
	if (! [userDefaults objectForKey:[delegate settingsKey]]) {
		[userDefaults setObject:[[[NSDictionary alloc] init] autorelease] forKey:[delegate settingsKey]];
	}

	// local defaults
	self.defaults = [[[userDefaults  dictionaryForKey:[delegate settingsKey]] mutableCopy] autorelease];

	// init
	self.settings = [[[NSMutableArray alloc] init] autorelease];
	
	// sorter
	NSSortDescriptor *sortSorter = [[NSSortDescriptor alloc] initWithKey:@"sort" ascending:YES];
	NSArray *sortSorters = [NSArray arrayWithObject:sortSorter];

	// load data
	NSSet *settingsSketch = [delegate settingsSketch];
	
	// groups
	NSMutableArray *groups = [NSMutableArray arrayWithArray:[settingsSketch allObjects]];
	[groups sortUsingDescriptors:sortSorters];
	
	// settings
	for (SettingGroup *group in groups) {
		GLog("Settings Group: %@", group.group);
	
		// settings
		GroupData *gdata = [[[GroupData alloc] init] autorelease];
		gdata.section = [group.name copy];
		
		NSMutableArray *groupsettings = [NSMutableArray arrayWithArray:[[group settings] allObjects]];
		gdata.data = [[[NSMutableArray alloc] init] autorelease];
		
		// recreate sketch settings objects
		for (Setting *s in groupsettings) {
			
			// setting
			SettingData *sd = [[[SettingData alloc] init] autorelease];
			sd.label = [s.label copy];
			sd.value = [s.value copy];
			sd.key = [s.key copy];
			sd.sort = [s.sort copy];
			sd.type = [s.type copy];
			sd.live = [s.live copy];
			sd.options = [s.options copy];
		
			// merge with defaults
			if ([defaults objectForKey:sd.key]) {
				sd.value = [defaults objectForKey:sd.key];
			}
			
			// add
			[gdata.data addObject:sd];

		}
		[gdata.data sortUsingDescriptors:sortSorters];
		
		// add to settings
		if ([gdata.data count] > 0) {
			[settings addObject:gdata]; 
		}
	}
	
	// release
	[sortSorter release];
	
	// reload table view
	[self.tableView reloadData];
}

/*
* Updates a setting.
*/
- (void)updateSetting:(NSString*)key value:(NSString*)v {
	FLog(@"key = %@, value = %@",key,v);
	
	// store in local settings
	BOOL live = NO;
	for (GroupData *gdata in settings) {
		for (Setting *s in gdata.data) {
			if ([key isEqualToString:s.key]) {
				s.value = v;
				if ([s.live boolValue]) {
					live = YES;
				}
				break;
			}
		}
	}
	// store in local defaults
	[defaults setObject:v forKey:key];
	
	// live update on ipad
	if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) && live) {
		[self updateLiveSetting:key value:v];
	}
	
	// set label
	NSNumber *tag = (NSNumber*) [tags objectForKey:key];
	CellInput *cell = (CellInput*) [self.tableView viewWithTag:[tag intValue]];
	[cell update:NO];
}

/*
* Updates a live setting.
*/
- (void)updateLiveSetting:(NSString *)key value:(NSString *)v {
	GLog(@"key = %@, value = %@",key,v);
	
	// update defaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSMutableDictionary *sketchDefaults = [[[userDefaults dictionaryForKey:[delegate settingsKey]] mutableCopy] autorelease];
	[sketchDefaults setObject:v forKey:key];
	
	// save
	[userDefaults setObject:sketchDefaults forKey:[delegate settingsKey]];
	[userDefaults synchronize];
	
	// update
	if (delegate != nil && [delegate respondsToSelector:@selector(settingsUpdate)]) {
		[delegate settingsUpdate];
	}
}



#pragma mark -
#pragma mark Cell Delegates

/*
* CellSwitch.
*/
- (void)cellSwitchChanged:(CellSwitch *)c {
	GLog();
	// updates
	[self updateSetting:c.key value:[NSString stringWithFormat:@"%@",[c.switchAccessory isOn] ? @"YES" : @"NO"]];
}

/*
* CellSlider.
*/
- (void)cellSliderChanged:(CellSlider *)c {
	GLog();
	// updates
	[self updateSetting:c.key value:[NSString stringWithFormat:@"{'value':%f,'min':%f,'max':%f}", [c.sliderAccessory value], [c.sliderAccessory minimumValue], [c.sliderAccessory maximumValue]]];
}

/*
* CellRange.
*/
- (void)cellRangeChanged:(CellRange *)c {
	GLog();
	// updates
	NSString *v = [NSString stringWithFormat:@"{'rmin':%f,'rmax':%f,'min':%f,'max':%f}",c.rangeAccessory.minSelectedValue, c.rangeAccessory.maxSelectedValue,c.rangeAccessory.minValue,c.rangeAccessory.maxValue];
	[self updateSetting:c.key value:v];
}

/*
* CellPicker.
*/
- (void)cellPickerChanged:(CellPicker *)c {
	GLog();
	// updates
	[self updateSetting:c.key value:c.pvalue];
	
	// back
	[self.navigationController popViewControllerAnimated:YES];
	
}

/*
 * CellColor.
 */
- (void)cellColorChanged:(CellColor *)c {
	GLog();
    
    // value
    NSString *v = [NSString stringWithFormat:@"{'rgb':true,'r':%f,'g':%f,'b':%f}",c.color_r, c.color_g, c.color_b];
    if (c.color_r < 0 || c.color_g < 0 || c.color_b < 0) {
        v = @"{'rgb':false}";
    }
	[self updateSetting:c.key value:v];
	
}
- (void)cellColorApply:(CellColor *)c {
	GLog();
    
    // apply all
    [self actionApply:c];
}


#pragma mark -
#pragma mark Actions

/*
* Processing reset.
*/
- (void)actionReset:(id)sender {
	DLog(@"defaults = %@",[delegate settingsKey]);
	
	
	// clear defaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults removeObjectForKey:[delegate settingsKey]];
	[userDefaults synchronize];
	
	// matrix reloaded
	[self reloadSettings];
	
	// delegate
	if (delegate != nil && [delegate respondsToSelector:@selector(settingsReset)]) {
		[delegate settingsReset];
	}
}

/*
* Apply.
*/
- (void)actionApply:(id)sender {
	DLog();
	
	// save defaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:defaults forKey:[delegate settingsKey]];
	[userDefaults synchronize];
	
	// delegate
	if (delegate != nil && [delegate respondsToSelector:@selector(settingsApply)]) {
		[delegate settingsApply];
	}

}




#pragma mark -
#pragma mark Table view data source

/*
 * Customize the number of sections in the table view.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
	// count it
    return [settings count];
}


/*
 * Customize the number of rows in the table view.
 */
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {

	// group
	GroupData *gdata = (GroupData*) [settings objectAtIndex:section];
	
	// data count
    return [gdata.data count];
}



#pragma mark -
#pragma mark UITableViewDelegate Protocol


/*
 * Section titles.
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

	// group
	GroupData *gdata = (GroupData*) [settings objectAtIndex:section];
	
	// section
	return [NSString stringWithFormat:@"%@",gdata.section];
}


/*
 * Customize the appearance of table view cells.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	// settings
	GroupData *gdata = (GroupData*) [settings objectAtIndex:[indexPath section]];
	SettingData *setting = [gdata.data objectAtIndex:[indexPath row]];
    
	// identifiers
    static NSString *CellIdentifier = @"CellSettings";
	static NSString *CellSwitchIdentifier = @"CellSettingsSwitch";
	static NSString *CellSliderIdentifier = @"CellSettingsSlider";
	static NSString *CellRangeIdentifier = @"CellSettingsRange";
	static NSString *CellPickerIdentifier = @"CellSettingsPicker";
    static NSString *CellColorIdentifier = @"CellSettingsColor";
	
	// crude hack to create a unique tag number
	NSNumber *tag = [NSNumber numberWithInt:([indexPath section]+1)*100+([indexPath row])];
	[tags setObject:tag forKey:setting.key];
	
	
	// cell
	UITableViewCell *cell;
	
	// cell switch
	if ([setting.type isEqualToString:@"switch"]) {
		FLog(@"switch");
		
		// create cell
		CellSwitch *cswitch = (CellSwitch*) [tableView dequeueReusableCellWithIdentifier:CellSwitchIdentifier];
		if (cswitch == nil) {
			cswitch = [[[CellSwitch alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellSwitchIdentifier] autorelease];
		}
		
		// prepare cell
		cswitch.delegate = self;
		cswitch.key = setting.key;
		BOOL on = NO;
		if ([setting.value isEqualToString:@"YES"]) {
			on = YES;
		}
		[cswitch.switchAccessory setOn:on]; 
		[cswitch update:YES];
		
		// set
		cell = cswitch;
	}
	// cell slider
	else if ([setting.type isEqualToString:@"slider"]) {
		FLog(@"slider");
		
		// create cell
		CellSlider *cslider = (CellSlider*) [tableView dequeueReusableCellWithIdentifier:CellSliderIdentifier];
		if (cslider == nil) {
			cslider = [[[CellSlider alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellSliderIdentifier] autorelease];
		}
		
		// values (expects a real json string with format {\"min\":\"5.0\",\"max\":\"15.0\"}
		NSString *valuesJSON = [setting.value stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
		NSDictionary *values = [valuesJSON JSONValue];

		
		// prepare cell
		cslider.delegate = self;
		cslider.key = setting.key;
		cslider.sliderAccessory.minimumValue = [[values objectForKey:@"min"] floatValue];
		cslider.sliderAccessory.maximumValue = [[values objectForKey:@"max"] floatValue];
		cslider.sliderAccessory.value = [[values objectForKey:@"value"] floatValue];
		[cslider update:YES];
		
		// set
		cell = cslider;
	}
	// cell range
	else if ([setting.type isEqualToString:@"range"]) {
		FLog(@"range");
		
		// create cell
		CellRange *crange = (CellRange*) [tableView dequeueReusableCellWithIdentifier:CellRangeIdentifier];
		if (crange == nil) {
			crange = [[[CellRange alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellRangeIdentifier] autorelease];
		}
		
		// values 
		NSString *valuesJSON = [setting.value stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
		NSDictionary *values = [valuesJSON JSONValue];
		
		// prepare cell
		crange.delegate = self;
		crange.key = setting.key;
		crange.rangeAccessory.minValue = [[values objectForKey:@"min"] floatValue];
		crange.rangeAccessory.maxValue = [[values objectForKey:@"max"] floatValue];
		crange.rangeAccessory.minSelectedValue = [[values objectForKey:@"rmin"] floatValue];
		crange.rangeAccessory.maxSelectedValue = [[values objectForKey:@"rmax"] floatValue];
		[crange update:YES];
		
		// set
		cell = crange;
		
	}
	// cell picker
	else if ([setting.type isEqualToString:@"picker"]) {
		FLog(@"picker");
		
		// create cell
		CellPicker *cpicker = (CellPicker*) [tableView dequeueReusableCellWithIdentifier:CellPickerIdentifier];
		if (cpicker == nil) {
			cpicker = [[[CellPicker alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellPickerIdentifier] autorelease];
		}
		
		// options 
		NSString *optionsJSON = [setting.options stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
		NSDictionary *options = [optionsJSON JSONValue];
		
		// picker values
		NSArray *pvalues = [options objectForKey:@"picker"];
		NSMutableArray *pdata = [[NSMutableArray alloc] init];
		int index = 0;
		for (NSDictionary *pvalue in pvalues)	{
			GLog(@"label = %@, value = %@",[pvalue objectForKey:@"label"],[pvalue objectForKey:@"value"]);
			[pdata addObject:[[ [PickerData alloc] initWithIndex:index label:[pvalue objectForKey:@"label"] value:[pvalue objectForKey:@"value"]] autorelease] ];
			
			// set cell
			if ([setting.value isEqualToString:[pvalue objectForKey:@"value"]]) {
				cpicker.pvalue = [pvalue objectForKey:@"value"];
				cpicker.plabel = [pvalue objectForKey:@"label"];
				cpicker.pindex = index;
			}
			
			// index
			index++;
		}
		
		// prepare cell
		cpicker.delegate = self;
		cpicker.key = setting.key;
		cpicker.label = setting.label;
		cpicker.values = pdata;
		[cpicker update:YES];
		
		// release
		[pdata release];

		
		// set
		cell = cpicker;
	}
    // cell color
	else if ([setting.type isEqualToString:@"color"]) {
		FLog(@"color");
		
		// create cell
		CellColor *ccolor = (CellColor*) [tableView dequeueReusableCellWithIdentifier:CellColorIdentifier];
		if (ccolor == nil) {
			ccolor = [[[CellColor alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellColorIdentifier] autorelease];
		}
        
        // values 
		NSString *valuesJSON = [setting.value stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
		NSDictionary *values = [valuesJSON JSONValue];
		
		// options 
		NSString *optionsJSON = [setting.options stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
		NSDictionary *options = [optionsJSON JSONValue];
		
		// swatches
        if ([options objectForKey:@"swatches"]) {
            
            // formater
            static NSNumberFormatter *nf = nil;
            if (nf == nil) {
                nf = [[NSNumberFormatter alloc] init];
                [nf setFormatterBehavior:NSNumberFormatterBehavior10_4];
                [nf setNumberStyle:NSNumberFormatterDecimalStyle];
            }
            
            // swatches
            NSArray *swatches = [options objectForKey:@"swatches"];
            NSMutableArray *colorSwatches = [[NSMutableArray alloc] init];
            for (NSDictionary *swatch in swatches)	{
                FLog(@"swatch = %@",[swatch objectForKey:@"label"]);
                [colorSwatches addObject:[[ColorSwatch alloc] initWithLabel:[swatch objectForKey:@"label"] 
                                                                 color:[UIColor colorWithRed:[[nf numberFromString:(NSString*)[swatch objectForKey:@"r"]] floatValue]
                                                                                       green:[[nf numberFromString:(NSString*)[swatch objectForKey:@"g"]] floatValue]
                                                                                        blue:[[nf numberFromString:(NSString*)[swatch objectForKey:@"b"]] floatValue]
                                                                                    alpha:1.0]]];
            }
            
            // set
            ccolor.swatches = colorSwatches;
            [colorSwatches release];
        }

		
		// prepare cell
		ccolor.delegate = self;
		ccolor.key = setting.key;
		ccolor.label = setting.label;
        
        
        // color
        ccolor.color_r = [values objectForKey:@"r"] ? [[values objectForKey:@"r"] floatValue] : -1;
        ccolor.color_g = [values objectForKey:@"g"] ? [[values objectForKey:@"g"] floatValue] : -1;
        ccolor.color_b = [values objectForKey:@"b"] ? [[values objectForKey:@"b"] floatValue] : -1;

		[ccolor update:YES];
        
		
		// set
		cell = ccolor;
	}
	// default
	else {
	
		// create cell
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.detailTextLabel.text = setting.value;
		}
	}
    
    // configure
	cell.tag = [tag intValue];
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0]; 
	cell.textLabel.textColor = [UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", setting.label];
	cell.backgroundColor = [UIColor	whiteColor];
	if ([setting.live boolValue] && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		cell.backgroundColor = [UIColor	colorWithRed:255.0/255.0 green:253.0/255.0 blue:235.0/255.0 alpha:1.0];
	}
	
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
	
	// settings
	GroupData *gdata = (GroupData*) [settings objectAtIndex:[indexPath section]];
	SettingData *setting = [gdata.data objectAtIndex:[indexPath row]];
	
	// picker
	if ([setting.type isEqualToString:@"picker"]) {
	
		// cell
		CellPicker *cpicker = (CellPicker*) [tableView cellForRowAtIndexPath:indexPath];
		
		// push controller
		[self.navigationController pushViewController:[cpicker pickerViewController:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] animated:YES];
		
		// modal mode
		[self setModeModal:YES];
	}
    // type
	else if ([setting.type isEqualToString:@"color"]) {
        
		// cell
		CellColor *ccolor = (CellColor*) [tableView cellForRowAtIndexPath:indexPath];
		
		// push controller
		[self.navigationController pushViewController:[ccolor colorViewController:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] animated:YES];
		
		// modal mode
		[self setModeModal:YES];
	}
	
}


#pragma mark -
#pragma mark Memory management



/**
* Deallocates all used memory.
*/
- (void)dealloc {
	GLog();
	
	// release
	[settings release];
	[defaults release];
	[tags release];
	
	// duper
    [super dealloc];
}


@end



/**
 * Group data.
 */
@implementation GroupData

#pragma mark -
#pragma mark Properties

// accessors
@synthesize section;
@synthesize data;


#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
	
	// self
	[section release];
	[data release];
	
	// super
    [super dealloc];
}

@end

/**
 * Setting data.
 */
@implementation SettingData

#pragma mark -
#pragma mark Properties

// accessors
@synthesize label;
@synthesize value;
@synthesize key;
@synthesize sort;
@synthesize type;
@synthesize live;
@synthesize options;


#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
	
	// self
	[label release];
	[value release];
	[key release];
	[sort release];
	[type release];
	[live release];
	[options release];
	
	// super
    [super dealloc];
}

@end



