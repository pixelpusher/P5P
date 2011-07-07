//
//  HTMLView.h
//  P5P
//
//  Created by CNPP on 23.1.2011.
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
