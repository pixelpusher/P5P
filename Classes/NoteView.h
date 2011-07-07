//
//  NoteView.h
//  P5P
//
//  Created by CNPP on 18.2.2011.
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
