//
//  InfoViewController.h
//  P5P
//
//  Created by CNPP on 17.2.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "CellButton.h"
#import "NoteView.h"
#import "TwitterComposeViewController.h"


//  Sections
enum {
    SectionInfoApp,
    SectionInfoRecommend,
	SectionInfoFeedback
} P5PInfoSections;


//  App Fields
enum {
	AppPreferences,
	AppCredits
} P5PInfoSectionApp;


//  Recommend Fields
enum {
	RecommendApp
} P5PInfoSectionRecommend;

//  Feedback Fields
enum {
	FeedbackSend
} P5PInfoSectionFeedback;

// actions
enum {
    InfoActionRecommend,
	InfoActionFeedback
} InfoActions;

// alerts
enum {
    InfoAlertRecommendAppStore
} InfoAlerts;


/*
* Info Delegate.
*/
@protocol InfoDelegate <NSObject>
- (void)dismissInfo;
- (UIImage*)randomSketchImage;
@end

/**
* Info Controller.
*/
@interface InfoViewController : UITableViewController <UIActionSheetDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate, TwitterComposeDelegate, CellButtonDelegate> {

	// delegate
	id<InfoDelegate> delegate;
	
	// note
	NoteView *note;

}

// Properties
@property (assign) id<InfoDelegate> delegate;

// Action Methods
- (void)actionDone:(id)sender;

@end
