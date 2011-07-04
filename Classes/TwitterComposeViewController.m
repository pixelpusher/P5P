    //
//  TwitterComposeViewController.m
//  P5P
//
//  Created by CNPP on 24.3.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "TwitterComposeViewController.h"
#import "JSON.h"


/*
* Helper Stack.
*/
@interface TwitterComposeViewController (Helpers)
- (void)showBlocker:(NSString*)msg;
- (void)updateBlocker:(NSString*)msg;
- (void)hideBlocker;
- (void)removeBlocker;
- (void)counter;
@end



/**
* TwitterComposeViewController.
*/
@implementation TwitterComposeViewController


#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;


// local vars
CGRect tframe;
float th = 180;
float bh = 40;
float inset = 20;


#pragma mark -
#pragma mark Object Methods

/*
* Init.
*/
-(id)init {
	return [self initWithFrame:CGRectMake(0, 0, 320, 480)];
}
-(id)initWithFrame:(CGRect)frame {
	GLog();
	// self
	if ((self = [super init])) {
	
		// view
		tframe = frame;
		
		// data
		status = [[NSMutableString alloc] init];
		
		// api
		twitterAPI = [[TwitterAPI alloc] init];
		twitterAPI.delegate = self;
		
		// mode
		mode_upload = NO;
        mode_test = NO;
	}
	return self;
}


#pragma mark -
#pragma mark View lifecycle


/*
* Loads the view.
*/
- (void)loadView {
	[super loadView];
	DLog();
	
	 // title
	self.navigationItem.title = NSLocalizedString(@"Twitter",@"Twitter");
	
	// navigation bar: publish button
	UIBarButtonItem *btnPublish = [[UIBarButtonItem alloc] 
								   initWithTitle:NSLocalizedString(@"Publish",@"Publish") 
								   style:UIBarButtonItemStylePlain 
								   target:self 
								   action:@selector(actionPublish:)];
	self.navigationItem.rightBarButtonItem = btnPublish;
	[btnPublish release];
	
	// navigation bar: cancel button
	UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] 
								   initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
								   target:self 
								   action:@selector(actionCancel:)];
	self.navigationItem.leftBarButtonItem = btnCancel;
	[btnCancel release];
	
	
	// view
	self.view = [[UIView alloc] initWithFrame:tframe];
	
	// background
	TwitterBackgroundView *twitterBG = [[TwitterBackgroundView alloc] initWithFrame:tframe];
	[self.view addSubview: twitterBG];
	[twitterBG release];
	
	
	// text view
	_textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, tframe.size.width, th)];
	_textView.delegate = self;
	_textView.editable = YES;
	_textView.keyboardType = UIKeyboardTypeEmailAddress;
	_textView.returnKeyType = UIReturnKeyDefault;
	_textView.autocorrectionType = UITextAutocorrectionTypeNo;
	_textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
	_textView.font = [UIFont fontWithName:@"Helvetica" size:15.0];
	_textView.textColor = [UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0];
	_textView.text = status;
	[self.view addSubview: _textView];
	
	
	// counter
	_labelCounter = [[UILabel alloc] initWithFrame:CGRectMake(tframe.size.width-40, th+12, 30, 20)];
	_labelCounter.backgroundColor = [UIColor clearColor];
	_labelCounter.font = [UIFont fontWithName:@"Helvetica" size:15.0];
	_labelCounter.textColor = [UIColor colorWithRed:140.0/255.0 green:140.0/255.0 blue:140.0/255.0 alpha:1.0];
	_labelCounter.shadowColor = [UIColor whiteColor];
	_labelCounter.shadowOffset = CGSizeMake(1,1);
	_labelCounter.backgroundColor = [UIColor clearColor];
	_labelCounter.opaque = YES;
	_labelCounter.numberOfLines = 1;
	_labelCounter.textAlignment = UITextAlignmentRight;
	[_labelCounter setText:@"140"];
	[self.view addSubview:_labelCounter];
	
	// image
	_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(inset, th+40+inset, tframe.size.width-2*inset, tframe.size.height-th-40-2*inset)];
	_imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	_imageView.backgroundColor = [UIColor whiteColor];
	_imageView.contentMode = UIViewContentModeScaleAspectFit;
	_imageView.backgroundColor = [UIColor clearColor];
	_imageView.opaque = YES;
	if (twitpic) {
		_imageView.image = twitpic;
	}
	[self.view addSubview:_imageView];
	

	// button photo
	_buttonPhoto = [UIButton buttonWithType:UIButtonTypeCustom]; 
	_buttonPhoto.frame = CGRectMake(2, th+6, 32, 32);
	[_buttonPhoto setImage:[UIImage imageNamed:@"btn_photo.png"] forState:UIControlStateNormal];
	[_buttonPhoto addTarget:self action:@selector(actionPhoto:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_buttonPhoto];
	
	
	// button attachment
	_buttonAttachment = [UIButton buttonWithType:UIButtonTypeCustom]; 
	_buttonAttachment.frame = CGRectMake(2, th+6, 32, 32);
	[_buttonAttachment setImage:[UIImage imageNamed:@"btn_attachment.png"] forState:UIControlStateNormal];
	[_buttonAttachment addTarget:self action:@selector(actionAttachment:) forControlEvents:UIControlEventTouchUpInside];
	_buttonAttachment.hidden = YES;
	[self.view addSubview:_buttonAttachment];
	if (twitpic) {
		_buttonAttachment.hidden = NO;
		_buttonPhoto.hidden = YES;
	}
	
	
	// loader
	_blockerView = [[UIView alloc] initWithFrame:tframe];
	_blockerView.backgroundColor = [UIColor blackColor];
	_blockerView.alpha = 0.0;
	
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	CGPoint spinnerCenter = CGPointMake(_blockerView.center.x, _blockerView.center.y-tframe.size.height/4.0);
	spinner.center = spinnerCenter;
	[spinner startAnimating];
	[_blockerView addSubview:spinner];
	[spinner release];
	
	_blockerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, spinnerCenter.y+30, tframe.size.width, 30)];
	_blockerLabel.textAlignment = UITextAlignmentCenter;
	_blockerLabel.backgroundColor = [UIColor clearColor];
	_blockerLabel.textColor = [UIColor whiteColor];
	_blockerLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
	[_blockerView addSubview:_blockerLabel];

	
	// hide it
	_blockerView.hidden = YES;
	[self.view addSubview:_blockerView];
	[self.view sendSubviewToBack:_blockerView];


}

/*
* Shows the view.
*/
- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	DLog();
	
	// twitter
	if ([twitterAPI authenticate]) {
	
		// keyboard
		[_textView becomeFirstResponder];

	}

}


#pragma mark -
#pragma mark Business Methods

/**
* Sets the initial status text.
*/
- (void)setStatusText:(NSString *)txt {
	FLog(@"%@",txt);
	
	// status
	[status setString:txt]; 
}


/**
* Sets a status image.
*/
- (void)setStatusImage:(UIImage *)img message:(NSString*)msg {
	FLog(@"%@",msg);
	
	// image
	twitpic = [img copy];
	message = [msg copy];
	
	// view
	if (_imageView) {
		_imageView.image = twitpic;
		_buttonAttachment.hidden = NO;
		_buttonPhoto.hidden = YES;
	}
	
	// mode
	mode_upload = YES;
}


/**
* Removes the status image.
*/
- (void)removeStatusImage {
	FLog();
	
	// image
	if (twitpic) {
	
		// image
		_imageView.image = nil;
	
		// pic
		[twitpic release];
		twitpic = nil;
		[message release];
		message = nil;
		
		// buttons
		_buttonAttachment.hidden = YES;
		_buttonPhoto.hidden = NO;
		
	}
	
	// mode
	mode_upload = NO;
}




/**
* Publish to twitter.
*/
- (void)publish {
	DLog(@"%@",status);
	
	// publish
	if ([self validate]) {
		[self showBlocker:NSLocalizedString(@"Publish on Twitter...",@"Publish on Twitter...")];
		[twitterAPI sendUpdate:status];
	}
}

/**
* Upload to twitpic.
*/
- (void)upload {
	DLog();
	
	// upload
	if ([self validate]) {
		[self showBlocker:NSLocalizedString(@"Upload Image...",@"Upload Image...")];
		[twitterAPI twitpicImageUpload:twitpic message:message];
	}
}


/**
* Validates the status.
*/
- (BOOL)validate {
	DLog();
	
	// restrain
	if ([status length] > 140 || (mode_upload && [status length] > 114)) {
	
		// blocker
		[self hideBlocker];
		
		// enable
		self.navigationItem.rightBarButtonItem.enabled = YES;
		
		// show info
		UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:NSLocalizedString(@"Message too long",@"Message too long")
						  message:NSLocalizedString(@"Twitter is limited to a maximum of 140 characters.",@"Twitter is limited to a maximum of 140 characters.") 
						  delegate:self 
						  cancelButtonTitle: @"OK"
						  otherButtonTitles:nil];
		[alert show];    
		[alert release];
		
		// nop
		return NO;
	}
	return YES;
}


#pragma mark -
#pragma mark Actions


/*
* Publish.
*/
- (void)actionPublish:(id)sender {
	DLog(@"status = %@",status);
	
	// disable
	self.navigationItem.rightBarButtonItem.enabled = NO;
	
	// close keyboard
	[_textView resignFirstResponder];
	
	
	// send stuff
    if (mode_test) {
        
        // demo
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Twitter",@"Twitter")
                              message:NSLocalizedString(@"Disabled for Beta Version.",@"Disabled for Beta Version.")
                              delegate:self 
                              cancelButtonTitle: @"OK"
                              otherButtonTitles:nil];
        [alert show];    
        [alert release];
    }
	else if (mode_upload) {
		[self upload];
	}
	else {
		[self publish];
	}
	
    

}

/*
* Cancel.
*/
- (void)actionCancel:(id)sender {
	DLog();
	
	// close keyboard
	[_textView resignFirstResponder];
	
	// dismiss
	if (delegate != nil && [delegate respondsToSelector:@selector(dismissTwitterCompose)]) {
		[delegate dismissTwitterCompose];
	}
}

/*
* Photo.
*/
- (void)actionPhoto:(id)sender {
	DLog();
	
	// image picker
	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	
	// present
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
	
		// popover
		if (_photoPopoverController == nil) {
			_photoPopoverController = [[UIPopoverController alloc] initWithContentViewController:imagePickerController]; 
			_photoPopoverController.delegate = self; 
			[_photoPopoverController setPopoverContentSize:CGSizeMake(320,480) animated:YES];
			[_photoPopoverController presentPopoverFromRect:_buttonPhoto.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

		}
		else {
			[_photoPopoverController dismissPopoverAnimated:YES];
		}
	}
	else {
		[self presentModalViewController:imagePickerController animated:YES];
	}
	
	[imagePickerController release];

}


/*
* Photo.
*/
- (void)actionAttachment:(id)sender {
	DLog();
	
	// action sheet
	UIActionSheet *attachmentAction = [[UIActionSheet alloc]
								  initWithTitle:NSLocalizedString(@"Attachment",@"Attachment")
								  delegate:self
								  cancelButtonTitle:NSLocalizedString(@"Cancel",@"Cancel")
								  destructiveButtonTitle:nil
								  otherButtonTitles:NSLocalizedString(@"Remove Attachment",@"Remove Attachment"),NSLocalizedString(@"Change Attachment",@"Change Attachment"),nil];
	
	// show
	[attachmentAction setTag:TwitterComposeActionAttachment];
	[attachmentAction showInView:self.navigationController.view];
	[attachmentAction release];

}


#pragma mark -
#pragma mark TwitterAPI Delegate


/**
 * Present authentication dialog.
 */
- (void)twitterAuthentication:(UIViewController *)controller {
	DLog();
	
	// show authentication
	controller.view.frame = self.view.bounds;
	[self presentModalViewController:controller animated:YES];
}

/**
 * Canceled.
 */
- (void)twitterAuthenticationCanceled {
	DLog();
	
	// dismiss
	if (delegate != nil && [delegate respondsToSelector:@selector(dismissTwitterCompose)]) {
		[delegate dismissTwitterCompose];
	}

}

/**
 * Canceled.
 */
- (void)twitterAuthenticationFailed {
	DLog();
	
	// dismiss
	if (delegate != nil && [delegate respondsToSelector:@selector(dismissTwitterCompose)]) {
		[delegate dismissTwitterCompose];
	}
	
}

/**
 * Success.
 */
- (void)twitterAuthenticationSuccess:(NSString*)username {
	DLog();
	
	// keyboard
	[_textView becomeFirstResponder];

}

/**
 * Request suceeded.
 */
- (void)twitterRequestSuceeded:(NSString *)connectionIdentifier {
	DLog(@"connection = %@",connectionIdentifier);
	
	
	// blocker
	[self hideBlocker];
	
	// dismiss
	if (delegate != nil && [delegate respondsToSelector:@selector(dismissTwitterCompose)]) {
		[delegate dismissTwitterCompose];
	}

}

/**
 * Request failed.
 */
- (void)twitterRequestFailed:(NSString *)connectionIdentifier {
	DLog(@"connection = %@",connectionIdentifier);
	
	// enable
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	// blocker
	[self hideBlocker];
	
	// show info
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:NSLocalizedString(@"Publishing Failed",@"Publishing Failed")
						  message:NSLocalizedString(@"Twitter is probably down. Please retry later.",@"Twitter is probably down. Please retry later.") 
						  delegate:self 
						  cancelButtonTitle: @"OK"
						  otherButtonTitles:nil];
	[alert show];    
	[alert release];
}


/**
* Twitpic upload finished.
*/
- (void)twitpicImageUploadFinished:(ASIHTTPRequest *)request {
	
	// response
	NSString *response = [request responseString];
    NSDictionary *twitpicResponse = [response   JSONValue];
	NSString *url = [twitpicResponse valueForKey:@"url"];
    FLog(@"url = %@",url);
	
	// leave mode
	mode_upload = NO;
	
	// append to status
	[status appendFormat:@" %@",url];
	_textView.text = status;
	
	// counter
	[self counter];
	
	// publish
	if ([self validate]) {
		[self updateBlocker:NSLocalizedString(@"Publish on Twitter...",@"Publish on Twitter...")];
		[twitterAPI sendUpdate:status];
	}

}

/**
* Twitpic upload failed.
*/
- (void)twitpicImageUploadFailed:(ASIHTTPRequest *)request {
	FLog();
	
	// enable
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	// blocker
	[self hideBlocker];
	
	// show info
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:NSLocalizedString(@"Publishing Failed",@"Publishing Failed")
						  message:NSLocalizedString(@"Could not upload image to TwitPic. Please retry later.",@"Could not upload image to TwitPic. Please retry later.") 
						  delegate:self 
						  cancelButtonTitle: @"OK"
						  otherButtonTitles:nil];
	[alert show];    
	[alert release];
}




#pragma mark -
#pragma mark UITextViewDelegate

/*
* Begin Editing.
*/
- (void)textViewDidBeginEditing:(UITextView *)textView {
	GLog();
	
	// set counter
	[self counter];
}

/*
* Change text.
*/
- (void)textViewDidChange:(UITextView *)textView {
	GLog();
	
	// status
	[status setString:[textView text]];
	
	// counter
	[self counter];
}


#pragma mark -
#pragma mark UIImagePickerDelegate

/*
* Picked an image.
*/
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {

	// set image
	[self setStatusImage:image message:NSLocalizedString(@"Generated with P5P. \nhttp://p5p.cecinestpasparis.net",@"Generated with P5P. \nhttp://p5p.cecinestpasparis.net")];

	// dismiss
	[picker dismissModalViewControllerAnimated:YES];
}

/*
* Didn't pick an image.
*/
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

	// dismiss
	[picker dismissModalViewControllerAnimated:YES];
}



#pragma mark -
#pragma mark UIActionSheet Delegate

/*
 * Action selected.
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	DLog();
	
	// tag
	switch ([actionSheet tag]) {
	
		// attachment
		case TwitterComposeActionAttachment: {
			// remove
			if (buttonIndex == 0) {
				[self removeStatusImage];
			} 
			// change
			if (buttonIndex == 1) {
				[self actionPhoto:self];
			} 
			break;
		}
		
		// default
		default: {
			break;
		}
	}
	
	
}


#pragma mark -
#pragma mark UIPopoverController Delegate

/*
* Dismiss.
*/
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	FLog();
	[_photoPopoverController release];
   _photoPopoverController = nil;
}


#pragma mark -
#pragma mark Helper Stack

/*
 * Shows/hides the loader.
 */
- (void)showBlocker:(NSString*)msg {
	FLog();
	
	// message
	[_blockerLabel setText:msg];
	
	// foreground
	[self.view bringSubviewToFront:_blockerView];

	// animate
	_blockerView.alpha = 0.0;
	_blockerView.hidden = NO;
	[UIView beginAnimations:@"blocker_show" context:NULL]; 
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5];
	_blockerView.alpha = 0.6;
	[UIView commitAnimations];
}
- (void)updateBlocker:(NSString*)msg {
	FLog();
	
	// message
	[_blockerLabel setText:msg];
}
- (void)hideBlocker {
	FLog();

	// animate
	[UIView beginAnimations:@"blocker_hide" context:NULL]; 
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDidStopSelector:@selector(removeBlocker)];
	_blockerView.alpha = 0.0;
	[UIView commitAnimations];
}
- (void)removeBlocker {
	GLog();
	
	// hide
	_blockerView.hidden = YES;
	_blockerView.alpha = 0.0;
	
	// background
	[self.view sendSubviewToBack:_blockerView];
}

/**
* Updates the counter.
*/
- (void)counter {
	FLog();
	
	// set counter
	NSInteger count = 140-[status length];
	if (mode_upload) {
		count -= 26;
	}
	[_labelCounter setText:[NSString stringWithFormat:@"%d", count]];
}




#pragma mark -
#pragma mark Memory management

/**
* Deallocates all used memory.
*/
- (void)dealloc {
	GLog();
	
	// ui
	[_textView release];
	[_labelCounter release];
	[_blockerView release];
	[_blockerLabel release];
	[_imageView release];
	[_buttonAttachment release];
	[_buttonPhoto release];
    
    // api
    [status release];
    [twitterAPI release];
    if (twitpic) {
        [twitpic release];
        twitpic = nil;
    }
    if (message) {
        [message release];
        message = nil;
    }
	
	
	// super
    [super dealloc];
}


@end



/**
* TwitterBackgroundView.
*/
@implementation TwitterBackgroundView


#pragma mark -
#pragma mark Object Methods

/*
 * Initialize.
 */
- (id)initWithFrame:(CGRect)frame {
	GLog();
		
	// init UIView
    self = [super initWithFrame:frame];
	
	// init self
    if (self != nil) {
		
		// add
		self.opaque = YES;
		self.backgroundColor = [UIColor whiteColor];

		// return
		return self;
	}
	
	// nop
	return nil;
}


/*
* Draw that thing.
*/
- (void)drawRect:(CGRect)rect {

	// vars
	float w = self.frame.size.width;
	float h = self.frame.size.height;
	
	// context
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextClearRect(context, rect);
	
	// white top
	CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
	CGContextFillRect(context, CGRectMake(0, 0, w, th));
	
	// grey bottom
	CGContextSetFillColorWithColor(context, [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0].CGColor);
	CGContextFillRect(context, CGRectMake(0, th, w, h-th));
	
	// gradient
	size_t num_locations = 2;
	CGFloat locations[2] = { 0.0, 1.0 };
	CGFloat components[8] = { 195.0/255.0, 195.0/255.0, 195.0/255.0, 1.0,    236.0/255.0, 236.0/255.0, 236.0/255.0, 1.0 };
	CGGradientRef gradient = CGGradientCreateWithColorComponents(CGColorSpaceCreateDeviceRGB(), components, locations, num_locations);
	
	CGPoint startPoint, endPoint;
	startPoint.x = 0.0;
	startPoint.y = th;
	endPoint.x = 0.0;
	endPoint.y = th+12;
	
	// drop that shadow
	CGContextSaveGState(context);
	CGContextAddRect(context, CGRectMake(0, th, w, 12));
	CGContextClip(context);
	CGContextDrawLinearGradient (context, gradient, startPoint, endPoint, 0);
	CGContextRestoreGState(context);
	
	
	// bar
	CGContextSetLineWidth(context, 1.0f);
	
	// bar top line
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0].CGColor);
	CGContextMoveToPoint(context, 0, th);
	CGContextAddLineToPoint(context, w, th);
	CGContextStrokePath(context);
	
	// bar bottom lines
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor);
	CGContextMoveToPoint(context, 0, th+bh);
	CGContextAddLineToPoint(context, w, th+bh);
	CGContextStrokePath(context);
	
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0].CGColor);
	CGContextMoveToPoint(context, 0, th+bh+1);
	CGContextAddLineToPoint(context, w, th+bh+1);
	CGContextStrokePath(context);
		
}



@end

