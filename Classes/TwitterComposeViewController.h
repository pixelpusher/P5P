//
//  TwitterComposeViewController.h
//  P5P
//
//  Created by CNPP on 24.3.2011.
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
#import "TwitterAPI.h"


// actions
enum {
    TwitterComposeActionAttachment
} TwitterComposeActions;


/*
* TwitterComposeDelegate.
*/
@protocol TwitterComposeDelegate <NSObject>
- (void)dismissTwitterCompose;
@end


/**
* TwitterComposeViewController.
*/
@interface TwitterComposeViewController : UIViewController <TwitterAPIDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIPopoverControllerDelegate> {

	// delegate
	id<TwitterComposeDelegate> delegate;
	
	// API
	TwitterAPI *twitterAPI;
	
	// data
	NSMutableString *status;
	UIImage *twitpic;
	NSString *message;
	
	// ui
	UITextView *_textView;
	UILabel *_labelCounter;
	UIView *_blockerView;
	UILabel *_blockerLabel;
	UIImageView *_imageView;
	UIButton *_buttonPhoto;
	UIButton *_buttonAttachment;
	UIPopoverController *_photoPopoverController;
	
	// mode
	@private 
	BOOL mode_upload;
    BOOL mode_test;

}

// Properties
@property (assign) id<TwitterComposeDelegate> delegate;

// Object Methods
- (id)initWithFrame:(CGRect)frame;

// Business Stuff
- (void)setStatusText:(NSString*)txt;
- (void)setStatusImage:(UIImage*)img message:(NSString*)msg;
- (void)removeStatusImage;
- (void)publish;
- (void)upload;
- (BOOL)validate;

// Actions
- (void)actionPublish:(id)sender;
- (void)actionCancel:(id)sender;
- (void)actionPhoto:(id)sender;
- (void)actionAttachment:(id)sender;

@end

/**
* TwitterBackgroundView.
*/
@interface TwitterBackgroundView : UIView {
}
@end

