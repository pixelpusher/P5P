//
//  TwitterComposeViewController.h
//  P5P
//
//  Created by CNPP on 24.3.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

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

