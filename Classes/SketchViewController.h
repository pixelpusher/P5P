//
//  SketchViewController.h
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

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
//#import <Accounts/Accounts.h>
//#import <Twitter/Twitter.h>
#import "TapDetectingWindow.h"
#import "P5PViewController.h"
#import "HTMLView.h"
#import "NoteView.h"
#import "SketchToolbar.h"
#import "SettingsViewController.h"


// declarations
@class Sketch;



// alerts
enum {
    P5PSketchCaptureSuccess,
	P5PSketchCaptureError,
	P5PSketchEmailSupport,
	P5PSketchPrintSupport,
	P5PSketchPrintError,
	P5PSketchPrintSuccess
} P5PSketchNotification;



/**
* SketchViewController.
*/
@interface SketchViewController : UIViewController <TapDetectingWindowDelegate, HTMLDelegate, SettingsDelegate, MFMailComposeViewControllerDelegate, UIPrintInteractionControllerDelegate, UIAlertViewDelegate, UIActionSheetDelegate> {

	// delegate
	id<P5PDelegate>delegate;

	// ui
	TapDetectingWindow *tapWindow;
	SketchToolbar *toolbar;
	UILabel *labelTitle;
	HTMLView *htmlView;
	NoteView *note;
	
	// controllers
	SettingsViewController *settingsViewController;
	
	// data
    Sketch *sketch;
	
	// modes
	BOOL modeModal;
	BOOL modeRefreshTap;
    BOOL modeToolbarAnimating;
    
	// private
	@private
	UIActionSheet *exportActionSheet;
}

// Properties
@property (assign) id<P5PDelegate> delegate;
@property (nonatomic, retain) Sketch *sketch;
@property BOOL modeModal;




// Helpers
- (void)showToolbar;
- (void)fadeoutToolbar;
- (void)showHideToolbar:(BOOL)animated;

// Business Methods
- (void)loadSketch;
- (void)reloadSketch;
- (void)unloadSketch;

// Actions
- (void)actionBack:(id)sender;
- (void)actionRefresh:(id)sender;
- (void)actionSettings:(id)sender;
- (void)actionExport:(id)sender;

@end
