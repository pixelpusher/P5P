//
//  TwitterAPI.h
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

#import "SA_OAuthTwitterController.h"
#import "ASIFormDataRequest.h"
#import "APIKeys.h"	
	

// User Default Keys
#define udTwitter				@"twitter"
#define udTwitterUser			@"twitter_user"	
#define udTwitterOAuthData		@"twitter_oauth_data"


/**
 * TwitterAPIDelegate Protocol.
 */
@protocol TwitterAPIDelegate <NSObject>
- (void)twitterAuthentication:(UIViewController*)controller;
@optional
- (void)twitterAuthenticationCanceled;
- (void)twitterAuthenticationFailed;
- (void)twitterAuthenticationSuccess:(NSString*)username;
- (void)twitterRequestSuceeded:(NSString *)connectionIdentifier;
- (void)twitterRequestFailed:(NSString *)connectionIdentifier;
- (void)twitpicImageUploadFinished:(ASIHTTPRequest *)request;
- (void)twitpicImageUploadFailed:(ASIHTTPRequest *)request;
@end

/**
* TwitterAPI Wrapper.
*/
@interface TwitterAPI : NSObject <SA_OAuthTwitterControllerDelegate> {

	// delegate
	id<TwitterAPIDelegate>delegate;
	
	// engine
	SA_OAuthTwitterEngine *_engine;

}

// Class Methods
+ (BOOL)authenticated;
+ (NSString*)username;

// Properties
@property (assign) id<TwitterAPIDelegate> delegate;

// Business Methods
- (void)remove;
- (BOOL)authenticate;
- (void)sendUpdate:(NSString*)status;
- (void)twitpicImageUpload:(UIImage*)img message:(NSString*)message;

@end
