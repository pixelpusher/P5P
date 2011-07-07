//
//  InfoViewController.h
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
