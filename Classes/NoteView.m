//
//  NoteView.m
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

#import "NoteView.h"
#import <QuartzCore/QuartzCore.h>


/**
 * Note Stack.
 */
@interface NoteView (AnimationHelpers)
- (void)animationShowNote;
- (void)animationShowNoteDone;
- (void)animationDismissNote;
- (void)animationDismissNoteDone;
- (void)prepareNotes;
- (void)animationShowNotification;
- (void)animationShowNotificationDone;
- (void)animationDismissNotification;
- (void)animationDismissNotificationDone;
- (void)prepareNotification;
@end


/**
* Note View.
*/
@implementation NoteView


#pragma mark -
#pragma mark Constants

// constants
#define kNoteOpacity                    0.8f
#define kNotificationOpacity            0.99f
#define kAnimateTimeNoteShow            0.18f
#define kAnimateTimeNoteDismiss         0.21f
#define kAnimateTimeNotificationShow	0.21f
#define kAnimateTimeNotificationDismiss 0.39f
#define kDelayTimeNoteDismiss           1.2f
#define kDelayTimeNotificationDismiss   1.2f


#pragma mark -
#pragma mark Object Methods

/*
 * Initialize.
 */
- (id)initWithFrame:(CGRect)frame {

	// size
	float nvs = 128;
	float inset = 10.0;
		
	// init UIView
    self = [super initWithFrame:frame];
	// init self
    if (self != nil) {
	

		
		// transparent view
		CGRect nframe = CGRectMake((frame.size.width/2.0)-nvs/2.0, (frame.size.height/2.0)-nvs/2.0, nvs, nvs);
		note = [[UIView alloc] initWithFrame:nframe];
		note.backgroundColor = [UIColor blackColor];
		note.alpha = kNoteOpacity;
		note.layer.cornerRadius = 10;
        
        CGRect nnframe = CGRectMake((frame.size.width/2.0)-1.5*nvs/2.0, (frame.size.height/2.0)-1.5*nvs/2.0, 1.5*nvs, 1.5*nvs);
		notification = [[UIView alloc] initWithFrame:nnframe];
		notification.backgroundColor = [UIColor whiteColor];
		notification.alpha = kNotificationOpacity;
		notification.layer.cornerRadius = 10;
        notification.layer.shadowOffset = CGSizeMake(5, 5);
        notification.layer.shadowRadius = 5;
        notification.layer.shadowOpacity = 0.5;

		
		// message
		msgNote = [[UILabel alloc] initWithFrame:CGRectMake(inset, nframe.size.height/2.0+nvs/16, nvs-2*inset, nvs/4)];
		msgNote.backgroundColor = [UIColor clearColor];
		
		msgNote.font = [UIFont fontWithName:@"Helvetica" size:12.0];
		msgNote.textAlignment = UITextAlignmentCenter;
		msgNote.textColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
		msgNote.numberOfLines = 2;

		msgNote.text = @"The Medium is the Message.";
		msgNote.hidden = YES;
        
        
        // message
		msgNotification = [[UILabel alloc] initWithFrame:CGRectMake(2*inset, nnframe.size.height/2.0-inset, nnframe.size.width-4*inset, nnframe.size.height/2.0)];
		msgNotification.backgroundColor = [UIColor clearColor];
		
		msgNotification.font = [UIFont fontWithName:@"Helvetica" size:15.0];
		msgNotification.textAlignment = UITextAlignmentCenter;
		msgNotification.textColor = [UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0];
		msgNotification.numberOfLines = 6;
        
		msgNotification.text = @"The Medium is still the Message.";
		msgNotification.hidden = YES;
        
		
		// icon center
		CGPoint iconNoteCenter = CGPointMake(nframe.size.width/2.0, nframe.size.height/2.0-nvs/8);
        CGPoint iconNotificationCenter = CGPointMake(nnframe.size.width/2.0, nnframe.size.height/2.0-nvs/4);
		CGRect iconNoteFrame = CGRectMake(iconNoteCenter.x-16, iconNoteCenter.y-16, 32, 32);
        CGRect iconNotificationFrame = CGRectMake(iconNotificationCenter.x-16, iconNotificationCenter.y-16, 32, 32);
		
		// loader
		activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		activity.center = iconNoteCenter;
		activity.hidden = YES;
		
		// success
		iconSuccess = [[UIImageView alloc] initWithFrame:iconNoteFrame];
		iconSuccess.image = [UIImage imageNamed:@"icon_note_success.png"];
		iconSuccess.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		iconSuccess.backgroundColor = [UIColor clearColor];
		iconSuccess.contentMode = UIViewContentModeCenter;
		iconSuccess.hidden = YES;
		
		// info
		iconInfo = [[UIImageView alloc] initWithFrame:iconNoteFrame];
		iconInfo.image = [UIImage imageNamed:@"icon_note_info.png"];
		iconInfo.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		iconInfo.backgroundColor = [UIColor clearColor];
		iconInfo.contentMode = UIViewContentModeCenter;
		iconInfo.hidden = YES;
		
		
		// error
		iconError = [[UIImageView alloc] initWithFrame:iconNoteFrame];
		iconError.image = [UIImage imageNamed:@"icon_note_error.png"];
		iconError.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		iconError.backgroundColor = [UIColor clearColor];
		iconError.contentMode = UIViewContentModeCenter;
		iconError.hidden = YES;
        
        
        // notification
		iconNotification = [[UIImageView alloc] initWithFrame:iconNotificationFrame];
		iconNotification.image = [UIImage imageNamed:@"icon_notification.png"];
		iconNotification.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		iconNotification.backgroundColor = [UIColor clearColor];
		iconNotification.contentMode = UIViewContentModeCenter;
		iconNotification.hidden = YES;
		
		
		
		// add
		[note addSubview:activity];
		[note addSubview:iconSuccess];
		[note addSubview:iconError];
		[note addSubview:iconInfo];
		[note addSubview:msgNote];
		note.hidden = YES;
        
        // add
        [notification addSubview:iconNotification];
		[notification addSubview:msgNotification];
		notification.hidden = YES;
		
		// add
		self.opaque = YES;
		self.backgroundColor = [UIColor clearColor];
		[self addSubview:note];
        [self addSubview:notification];
		
		// hide
		self.hidden = YES;

		// return
		return self;
	}
	
	// nop
	return nil;
}


#pragma mark -
#pragma mark Touch

/*
 * Touch.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	FLog();
    [self dismissNotificationAfterDelay:0];
}



#pragma mark -
#pragma mark Business Methods

/**
* Notes an activity.
*/
- (void)noteActivity:(NSString *)msg {
	FLog();
	
	// reset
	[self prepareNotes];
	
	// text
	msgNote.text = msg;
	msgNote.hidden = NO;
	
	// activity
	activity.hidden = NO;
	[activity startAnimating];
}

/**
* Notes a success.
*/
- (void)noteSuccess:(NSString *)msg {
	FLog();
	
	[self prepareNotes];
	
	// text
	msgNote.text = msg;
	msgNote.hidden = NO;
	
	// success
	iconSuccess.hidden = NO;
}

/**
* Notes an error.
*/
- (void)noteError:(NSString *)msg {
	FLog();
	
	[self prepareNotes];
	
	// text
	msgNote.text = msg;
	msgNote.hidden = NO;
	
	// error
	iconError.hidden = NO;
}

/**
* Notes an info.
*/
- (void)noteInfo:(NSString *)msg {
	FLog();
	
	[self prepareNotes];
	
	// text
	msgNote.text = msg;
	msgNote.hidden = NO;
	
	// info
	iconInfo.hidden = NO;
}



/**
 * Notification.
 */
- (void)notificationInfo:(NSString *)msg {
	FLog();
    
    [self prepareNotification];
    
    // text
	msgNotification.text = msg;
    msgNotification.hidden = NO;
    
    // icons
    iconNotification.hidden = NO;

}



#pragma mark -
#pragma mark Note


/**
 * Shows the note.
 */
 - (void)showNote {
	[self performSelector:@selector(animationShowNote) withObject:nil afterDelay:0];
}
- (void)showNoteAfterDelay:(float)delay {
	[self performSelector:@selector(animationShowNote) withObject:nil afterDelay:delay];
}



/*
* Animation note show.
*/
- (void)animationShowNote {
	DLog();
 
	// prepare view
	note.alpha = 0.0f;
	note.transform = CGAffineTransformMakeScale(0.1,0.1);
	note.hidden = NO;
	self.hidden = NO;
 
	// animate
	[UIView beginAnimations:@"note_show" context:nil];
	[UIView setAnimationDuration:kAnimateTimeNoteShow];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	note.alpha = kNoteOpacity;
	note.transform = CGAffineTransformMakeScale(1,1);
	[UIView commitAnimations];
 
	// clean it up
	[self performSelector:@selector(animationShowNoteDone) withObject:nil afterDelay:kAnimateTimeNoteShow];
}
- (void) animationShowNoteDone {
	GLog();
}

/**
 * Dismisses the note.
 */
- (void)dismissNote {
    FLog();
	[self performSelector:@selector(animationDismissNote) withObject:nil afterDelay:kDelayTimeNoteDismiss];
}
- (void)dismissNoteAfterDelay:(float)delay {
    FLog();
	[self performSelector:@selector(animationDismissNote) withObject:nil afterDelay:delay];
}


/*
* Animation note dismiss.
*/
- (void)animationDismissNote {
	DLog();
	
	// prepare view
	note.alpha = kNoteOpacity;
 
	// animate
	[UIView beginAnimations:@"note_dismiss" context:nil];
	[UIView setAnimationDuration:kAnimateTimeNoteDismiss];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	note.alpha = 0.0f;
	note.transform = CGAffineTransformMakeScale(1.5,1.5);
	[UIView commitAnimations];
 
	// clean it up
	[self performSelector:@selector(animationDismissNoteDone) withObject:nil afterDelay:kAnimateTimeNoteDismiss];
	
}
- (void) animationDismissNoteDone {
	GLog();
	// hide
	note.hidden = YES;
	note.transform = CGAffineTransformMakeScale(1,1);
	self.hidden = YES;
	
	// reset
	[self prepareNotes];
}


/*
* Resets the various notes.
*/
- (void)prepareNotes {

	// message
	msgNote.text = @"";
	msgNote.hidden = YES;

	// activity
	[activity stopAnimating];
	activity.hidden = YES;
	
	// success
	iconSuccess.hidden = YES;
	
	// error
	iconError.hidden = YES;
	
	// info
	iconInfo.hidden = YES;
    
    // swap
    note.hidden = NO;
    notification.hidden = YES;
    [self bringSubviewToFront:note];

}



#pragma mark -
#pragma mark Notification


/**
 * Shows the notification.
 */
- (void)showNotification {
	[self performSelector:@selector(animationShowNotification) withObject:nil afterDelay:0];
}
- (void)showNotificationAfterDelay:(float)delay {
	[self performSelector:@selector(animationShowNotification) withObject:nil afterDelay:delay];
}



/*
 * Animation notification show.
 */
- (void)animationShowNotification {
	DLog();
    
	// prepare view
	notification.alpha = 0.0f;
	notification.transform = CGAffineTransformMakeScale(1.5,1.5);
	notification.hidden = NO;
	self.hidden = NO;
    
	// animate
	[UIView beginAnimations:@"notification_show" context:nil];
	[UIView setAnimationDuration:kAnimateTimeNotificationShow];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	notification.alpha = kNotificationOpacity;
	notification.transform = CGAffineTransformMakeScale(1,1);
	[UIView commitAnimations];
    
	// clean it up
	[self performSelector:@selector(animationShowNotificationDone) withObject:nil afterDelay:kAnimateTimeNotificationShow];
}
- (void) animationShowNotificationDone {
	GLog();
}

/**
 * Dismisses the notification.
 */
- (void)dismissNotification {
    FLog();
	[self performSelector:@selector(animationDismissNotification) withObject:nil afterDelay:kDelayTimeNotificationDismiss];
}
- (void)dismissNotificationAfterDelay:(float)delay {
    FLog();
	[self performSelector:@selector(animationDismissNotification) withObject:nil afterDelay:delay];
}


/*
 * Animation notification dismiss.
 */
- (void)animationDismissNotification {
	DLog();
	
	// prepare view
	notification.alpha = kNotificationOpacity;
    
	// animate
	[UIView beginAnimations:@"notification_dismiss" context:nil];
	[UIView setAnimationDuration:kAnimateTimeNotificationDismiss];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	notification.alpha = 0.0f;
	notification.transform = CGAffineTransformMakeScale(0.1,0.1);
	[UIView commitAnimations];
    
	// clean it up
	[self performSelector:@selector(animationDismissNotificationDone) withObject:nil afterDelay:kAnimateTimeNotificationDismiss];
	
}
- (void) animationDismissNotificationDone {
	GLog();
	// hide
	notification.hidden = YES;
	notification.transform = CGAffineTransformMakeScale(1,1);
	self.hidden = YES;
	
	// reset
	[self prepareNotes];
}


/*
 * Resets the various notes.
 */
- (void)prepareNotification {
    
    // icons
    iconNotification.hidden = YES;
    
    // message
	msgNotification.text = @"";
	msgNotification.hidden = YES;
    
    // swap
    note.hidden = YES;
    notification.hidden = NO;
    [self bringSubviewToFront:notification];
    
}


#pragma mark -
#pragma mark Memory Management


/*
 * Deallocates all used memory.
 */
- (void)dealloc {	
	GLog();
	
	// release
	[msgNote release];
    [msgNotification release];
	[activity release];
	[iconSuccess release];
	[iconError release];
	[iconInfo release];
	[note release];
	
	// supimessage
	[super dealloc];
}

@end
