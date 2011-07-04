//
//  NoteView.h
//  P5P
//
//  Created by CNPP on 18.2.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>


/*
* Note View.
*/
@interface NoteView : UIView {

	// ui
	UIView *note;
    UIView *notification;
	UILabel *msgNote;
    UILabel *msgNotification;
	UIActivityIndicatorView *activity;
	UIImageView *iconInfo;
	UIImageView *iconSuccess;
	UIImageView *iconError;
    UIImageView *iconNotification;

}

// Business Methods
- (void)noteActivity:(NSString*)msg;
- (void)noteInfo:(NSString*)msg;
- (void)noteSuccess:(NSString*)msg;
- (void)noteError:(NSString*)msg;
- (void)notificationInfo:(NSString*)msg;
- (void)showNote;
- (void)showNoteAfterDelay:(float)delay;
- (void)showNotification;
- (void)showNotificationAfterDelay:(float)delay;
- (void)dismissNote;
- (void)dismissNoteAfterDelay:(float)delay;
- (void)dismissNotification;
- (void)dismissNotificationAfterDelay:(float)delay;


@end
