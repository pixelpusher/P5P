//
//  TwitterAPI.m
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

#import "TwitterAPI.h"
#import "OAuth.h"
#import "OAToken.h"
#import "SA_OAuthTwitterEngine.h"
#import "JSON.h"


/*
* Helper Stack.
*/
@interface TwitterAPI (Helpers)
- (void)uploadImageFinished:(ASIHTTPRequest*)request;
- (void)uploadImageFailed:(ASIHTTPRequest*)request;
@end

/**
* TwitterAPI Wrapper.
*/
@implementation TwitterAPI


#pragma mark -
#pragma mark Class Methods

/*
 * Indicates if authenticated.
 */
+ (BOOL)authenticated {
	return [[NSUserDefaults standardUserDefaults] boolForKey:udTwitter];
}

/*
 * Returnes the username.
 */
+ (NSString*)username {
	return [[NSUserDefaults standardUserDefaults] objectForKey:udTwitterUser];
}


#pragma mark -
#pragma mark Properties

// synthesize accessors
@synthesize delegate;


#pragma mark -
#pragma mark Object Methods

/*
 * Init.
 */
- (id)init {
	// super
	if ((self = [super init])) {
	
		// init engine
		_engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
		_engine.consumerKey = kTwitterOAuthConsumerKey;
		_engine.consumerSecret = kTwitterOAuthConsumerSecret;

	}
	
	// return
	return self;
}



#pragma mark -
#pragma mark Business Methods


/**
 * Authenticate user.
 */
- (BOOL)authenticate {
	FLog();
	
	// controller
	UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate:self];
	if (controller) {
		// authentication required
		if (self.delegate && [self.delegate respondsToSelector:@selector(twitterAuthentication:)]) {
			[self.delegate twitterAuthentication:controller];
			return NO;
		}
	}
	
	// ok
	return YES;
}

/**
 * Removes the authentication.
 */
- (void)remove {
	DLog();
	
	// user defaults 
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults removeObjectForKey:udTwitterUser];
	[userDefaults removeObjectForKey:udTwitterOAuthData];
	[userDefaults removeObjectForKey:udTwitter];
	[userDefaults synchronize];
}

/**
 * Sends a status update.
 */
- (void)sendUpdate:(NSString*)status {
	DLog(@"status = %@",status);
	
	// send update
	[_engine sendUpdate:status];
}



/**
* Uploads an image.
*/
- (void)twitpicImageUpload:(UIImage *)img message:(NSString *)message {
	DLog();

	// OAuth data
	NSString *oAuthData = [[NSUserDefaults standardUserDefaults] objectForKey: udTwitterOAuthData];
	OAToken *oAuthToken = [[[OAToken alloc] initWithHTTPResponseBody:oAuthData] autorelease];

	// OAuth
	OAuth *oAuth = [[[OAuth alloc] initWithConsumerKey:kTwitterOAuthConsumerKey andConsumerSecret:kTwitterOAuthConsumerSecret] autorelease];
	oAuth.oauth_token = oAuthToken.key;
	oAuth.oauth_token_secret = oAuthToken.secret;
	oAuth.oauth_token_authorized = YES;

	// request
	ASIFormDataRequest *req = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitpic.com/2/upload.json"]] autorelease];
    [req setPostValue:[NSString stringWithFormat:@"%i",rand()] forKey:@"rand"];
    [req addRequestHeader:@"X-Auth-Service-Provider" value:@"https://api.twitter.com/1/account/verify_credentials.json"];
    [req addRequestHeader:@"X-Verify-Credentials-Authorization"
                    value:[oAuth oAuthHeaderForMethod:@"GET"
                                               andUrl:@"https://api.twitter.com/1/account/verify_credentials.json"
                                            andParams:nil]];   
	[req setPostValue:kTwitPicAPI forKey:@"key"];
    
	// data
    [req setData:UIImageJPEGRepresentation(img, 1.0) forKey:@"media"];
    [req setPostValue:message forKey:@"message"];
    
	// send
	[req setDelegate:self];
	[req setDidFailSelector:@selector(uploadImageFailed:)];
	[req setDidFinishSelector:@selector(uploadImageFinished:)];
    [req setTimeOutSeconds:15];
    [req startAsynchronous];
	

}


/*
* Upload failed.
*/
- (void)uploadImageFailed:(ASIHTTPRequest*)request {
	FLog();
  
	// delegate
	if (self.delegate && [self.delegate respondsToSelector:@selector(twitpicImageUploadFailed:)]) {
		[self.delegate twitpicImageUploadFailed:request];
	}
}


/*
* Upload finished.
*/
- (void)uploadImageFinished:(ASIHTTPRequest*)request {
	FLog();
  
	// delegate
	if (self.delegate && [self.delegate respondsToSelector:@selector(twitpicImageUploadFinished:)]) {
		[self.delegate twitpicImageUploadFinished:request];
	}
}





#pragma mark -
#pragma mark SA_OAuthTwitterEngineDelegate

/*
 * Store authentication.
 */
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	FLog(@"username = %@",username);
	
	
	// user defaults 
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:username forKey: udTwitterUser];
	[userDefaults setObject:data forKey: udTwitterOAuthData];
	[userDefaults setBool:YES forKey:udTwitter];
	[userDefaults synchronize];

}

/*
 * Retrieve stored authentication.
 */
- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	FLog();
	return [[NSUserDefaults standardUserDefaults] objectForKey: udTwitterOAuthData];
}


#pragma mark -
#pragma mark SA_OAuthTwitterControllerDelegate

/*
 * Authenticated.
 */
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
	FLog(@"Authenicated for %@", username);
	
	// delegate
	if (self.delegate && [self.delegate respondsToSelector:@selector(twitterAuthenticationSuccess:)]) {
		[self.delegate twitterAuthenticationSuccess:username];
	}
}

/*
 * Failed.
 */
- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	FLog(@"Authentication Failed!");
	
	// delegate
	if (self.delegate && [self.delegate respondsToSelector:@selector(twitterAuthenticationCanceled)]) {
		[self.delegate twitterAuthenticationFailed];
	}
}

/*
 * Canceled.
 */
- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	FLog(@"Authentication Canceled.");
	
	// delegate
	if (self.delegate && [self.delegate respondsToSelector:@selector(twitterAuthenticationCanceled)]) {
		[self.delegate twitterAuthenticationCanceled];
	}
}


#pragma mark -
#pragma mark MGTwitterEngineDelegate Methods

/*
 * Request suceeded.
 */
- (void)requestSucceeded:(NSString *)connectionIdentifier {
	FLog(@"Request Suceeded: %@", connectionIdentifier);
	if (self.delegate && [self.delegate respondsToSelector:@selector(twitterRequestSuceeded:)]) {
		[self.delegate twitterRequestSuceeded:connectionIdentifier];
	}
}

/*
 * Request failed.
 */
- (void)requestFailed:(NSString*) connectionIdentifier {
	FLog(@"Request Failed: %@", connectionIdentifier);
	if (self.delegate && [self.delegate respondsToSelector:@selector(twitterRequestFailed:)]) {
		[self.delegate twitterRequestFailed:connectionIdentifier];
	}
}



#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	
	// self
	[_engine release];
	
	// super
    [super dealloc];
}

@end
