//
//  HTMLView.h
//  P5P
//
//  Created by CNPP on 23.1.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "JSON/JSON.h"
#import "DeviceMotion.h"

/**
 * HTMLDelegate Protocol.
 */
@protocol HTMLDelegate <NSObject>
	/**
	* Page Properties.
	* @JS Object PageInfo or window.PageInfo
	*/
	- (NSDictionary*) pageProperties;
	
	/**
	* User Defaults.
	* @JS Object UserDefaults or window.UserDefaults
	*/
	@optional
	- (NSDictionary*) userDefaults;
	
	/**
	* Page loaded and ready.
	*/
	@optional
	- (void)pageLoaded;
@end



/**
 * HTMLView.
 * @source Based on PhoneGap
 */
@interface HTMLView : UIView <UIWebViewDelegate> {

	// delegate
	id<HTMLDelegate>delegate;
	
	// UI
	UIWebView *webView;
	
	// utilities
	@private
	DeviceMotion *deviceMotion;

}

// Properties
@property (assign) id<HTMLDelegate> delegate;
@property (nonatomic, retain) UIWebView *webView;

// Object Methods
- (id)initWithFrame:(CGRect)frame scrolling:(BOOL)bounces;

// Methods
- (BOOL)loadPage:(NSString*)page;
- (BOOL)refreshPage;
- (BOOL)updatePage;
- (BOOL)unloadPage;
- (BOOL)reloadPage;
- (UIImage*)screenshot;
- (void)dispatchEvent:(NSString*)type data:(NSString*)dta;
- (NSDictionary*) deviceProperties;
- (NSDictionary*) userDefaults;
- (NSString*) pathForResource:(NSString*)resourcepath;

// Commands
- (void) exec:(NSURL*)url;
- (void) javascriptAlert:(NSString*)text;
- (void) log:(NSString*)msg;
- (void) acceleration:(NSString*)dir;

@end
