//
//  TwitterAPI.h
//  P5P
//
//  Created by CNPP on 24.3.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
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
