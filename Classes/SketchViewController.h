//
//  SketchViewController.h
//  P5P
//
//  Created by CNPP on 28.1.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "TwitterComposeViewController.h"
#import "TapDetectingWindow.h"
#import "P5PViewController.h"
#import "HTMLView.h"
#import "NoteView.h"
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
@interface SketchViewController : UIViewController <TapDetectingWindowDelegate, HTMLDelegate, SettingsDelegate, MFMailComposeViewControllerDelegate, TwitterComposeDelegate, UIPrintInteractionControllerDelegate, UIAlertViewDelegate, UIActionSheetDelegate> {

	// delegate
	id<P5PDelegate>delegate;

	// ui
	TapDetectingWindow *tapWindow;
	UIToolbar *toolbar;
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
