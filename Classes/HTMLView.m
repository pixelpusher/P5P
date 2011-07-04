//
//  HTMLView.m
//  P5P
//
//  Created by CNPP on 23.1.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "HTMLView.h"



/*
* Helper Stack.
*/
@interface HTMLView (Helpers)
- (NSMutableString*)cleanupJSON:(NSMutableString*)s;
@end


/**
 * HTMLView.
 */
@implementation HTMLView


#pragma mark -
#pragma mark Properties

// synthesize accessors
@synthesize delegate;
@synthesize webView;



#pragma mark -
#pragma mark Object Methods

/*
 * Initialize.
 */
- (id) initWithFrame:(CGRect)frame {
	return [self initWithFrame:frame scrolling:YES];
}
- (id) initWithFrame:(CGRect)frame scrolling:(BOOL)bounces {
	GLog();
	
	// init UIView
    self = [super initWithFrame:frame];
	
	// init HTMLView
    if (self != nil) {
	
		// init utils
		deviceMotion = [[DeviceMotion alloc] init];
		
		// init web view
		webView = [ [ UIWebView alloc ] initWithFrame:self.bounds];
		[webView setAutoresizingMask: (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight) ];
		webView.backgroundColor = self.backgroundColor;
		webView.delegate = self;
		
		// bounces
		if (! bounces) {
			UIScrollView* sv = nil;
			for(UIView* v in webView.subviews){
				if([v isKindOfClass:[UIScrollView class] ]){
					sv = (UIScrollView*) v;
					sv.scrollEnabled = NO;
					sv.bounces = NO;
				}
			}
		}
		
		
		// add it
		[self addSubview:webView];

    }
    return self; 
}


#pragma mark -
#pragma mark HTMLView Interface

/**
 * Loads a page.
 */
- (BOOL)loadPage:(NSString*)page {
	DLog(@"%@", page);
	
	// load request
	NSURL *appURL = [NSURL fileURLWithPath:[self pathForResource:page]];
	NSURLRequest *appReq = [NSURLRequest requestWithURL:appURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
	[webView loadRequest:appReq];
	
	// return
	return YES;
}

/**
 * Refreshes a loaded page.
 */
- (BOOL)refreshPage {
	DLog();
	
	// yippy
	NSMutableString *result = [[NSMutableString alloc] initWithString:@""];
	
	// custom user defaults
	if (delegate != nil && [delegate respondsToSelector:@selector(userDefaults)]) {
		[result appendFormat:@"\nwindow.UserDefaults = %@;", [[delegate userDefaults] JSONRepresentation]];
	}
	// default
	else {
		[result appendFormat:@"\nwindow.UserDefaults = %@;", [[self userDefaults] JSONRepresentation]];
	}
	
	// cleanup
	result = [self cleanupJSON:result];

	
	// refresh device
    DLog(@"Device refresh: %@", result);
    [webView stringByEvaluatingJavaScriptFromString:result];
	[result release];
	
	// dispatch
	[self dispatchEvent:@"device_refresh" data:@""];
	
	// return
	return YES;
}

/**
 * Updates a loaded page.
 */
- (BOOL)updatePage {
	DLog();
	
	// yippy
	NSMutableString *result = [[NSMutableString alloc] initWithString:@""];
	
	// custom user defaults
	if (delegate != nil && [delegate respondsToSelector:@selector(userDefaults)]) {
		[result appendFormat:@"\nwindow.UserDefaults = %@;", [[delegate userDefaults] JSONRepresentation]];
	}
	// default
	else {
		[result appendFormat:@"\nwindow.UserDefaults = %@;", [[self userDefaults] JSONRepresentation]];
	}
	
	// cleanup
	result = [self cleanupJSON:result];
	
	// update device
    DLog(@"Device update: %@", result);
    [webView stringByEvaluatingJavaScriptFromString:result];
	[result release];
	
	// dispatch
	[self dispatchEvent:@"device_update" data:@""];
	
	// return
	return YES;
}

/**
 * Unloads a page.
 */
- (BOOL)unloadPage {
	DLog();
	
	// result
	NSMutableString *result = [[NSMutableString alloc] initWithString:@""];
	[result appendString:@"\nwindow.PageSettings = {};"];
	[result appendString:@"\nwindow.UserDefaults = {};"];
	[result appendString:@"\nwindow.UserDefaults = {};"];
	
	// cleanup
	result = [self cleanupJSON:result];
	
	// init device
    DLog(@"Device unload: %@", result);
    [webView stringByEvaluatingJavaScriptFromString:result];
	[result release];
	
	// dispatch
	[self dispatchEvent:@"device_unload" data:@""];

	// return
	return YES;
}


/**
 * Reloads a previously loaded page.
 */
- (BOOL)reloadPage {
	DLog();
	
	// result
	NSMutableString *result = [[NSMutableString alloc] initWithString:@""];
	
	
	// page properties
	if (delegate != nil && [delegate respondsToSelector:@selector(pageProperties)]) {
		[result appendFormat:@"\nwindow.PageSettings = %@;", [[delegate pageProperties] JSONRepresentation]];
	}
	
	// custom user defaults
	if (delegate != nil && [delegate respondsToSelector:@selector(userDefaults)]) {
		[result appendFormat:@"\nwindow.UserDefaults = %@;", [[delegate userDefaults] JSONRepresentation]];
	}
	// default
	else {
		[result appendFormat:@"\nwindow.UserDefaults = %@;", [[self userDefaults] JSONRepresentation]];
	}
	
	
	// cleanup
	result = [self cleanupJSON:result];
	
	// reload device
    DLog(@"Device reload: %@", result);
    [webView stringByEvaluatingJavaScriptFromString:result];
	[result release];
	
	// dispatch
	[self dispatchEvent:@"device_reload" data:@""];

	
	// return
	return YES;
}


/**
* Dispatches an event.
*/
- (void)dispatchEvent:(NSString*)type data:(NSString*)dta {
	DLog(@"type = %@, data = %@",type,dta);
	
	// event
	NSMutableString *result = [[NSMutableString alloc] initWithFormat:@"DeviceEvent = {'available':true,'type':'%@','data':'%@'}",type,dta];
	
	// eval
	[webView stringByEvaluatingJavaScriptFromString:result];
	[result release];
}

/**
* Takes a screenshot.
*/
- (UIImage*)screenshot {
	DLog();	
	
	// tha image
	UIImage* screen = nil;
	UIGraphicsBeginImageContext(webView.frame.size);
	[webView.layer renderInContext:UIGraphicsGetCurrentContext()];
	screen = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    // release
    //webView.layer.contents = nil;
	
	// png wrapper (better quality?)
	//UIImage* im = [UIImage imageWithCGImage:myCGRef]; // make image from CGRef
	//NSData* png = UIImagePNGRepresentation (screen); // get PNG representation
	//UIImage* export = [UIImage imageWithData:png]; // wrap UIImage around PNG representation
  
	// return
	return screen;
}




#pragma mark -
#pragma mark WebView Delegate

/*
 * Called when the webview finishes loading.
 */
- (void)webViewDidFinishLoad:(UIWebView *)theWebView {
	DLog();
	
	// device properties
    NSMutableString *result = [[NSMutableString alloc] initWithFormat:@"DeviceSettings = %@;", [[self deviceProperties] JSONRepresentation]];
    
	
	// page properties
	if (delegate != nil && [delegate respondsToSelector:@selector(pageProperties)]) {
		[result appendFormat:@"\nwindow.PageSettings = %@;", [[delegate pageProperties] JSONRepresentation]];
	}
	
	// custom user defaults
	if (delegate != nil && [delegate respondsToSelector:@selector(userDefaults)]) {
		[result appendFormat:@"\nwindow.UserDefaults = %@;", [[delegate userDefaults] JSONRepresentation]];
	}
	// default
	else {
		[result appendFormat:@"\nwindow.UserDefaults = %@;", [[self userDefaults] JSONRepresentation]];
	}
	
	// cleanup
	result = [self cleanupJSON:result];
	
	// init device
    DLog(@"Device initialization: %@", result);
    [theWebView stringByEvaluatingJavaScriptFromString:result];
	[result release];
	
	// dispatch
	[self dispatchEvent:@"device_ready" data:@""];
	
	// loaded
	if (delegate != nil && [delegate respondsToSelector:@selector(pageLoaded)]) {
		[delegate pageLoaded];
	}
	
}



/*
 * Start Loading Request
 * This is where most of the magic happens... We take the request(s) and process the response.
 * From here we can re direct links and other protocalls to different internal methods.
 */
- (BOOL)webView:(UIWebView *)theWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	
	// url
	NSURL *url = [request URL];
	
	// device command
	if ([[url scheme] isEqualToString:@"ios"]) {
		[self exec:url];
		return NO;
	}
    
    // If a URL is being loaded that's a local file URL, just load it internally
    else if ([url isFileURL]) {
        return YES;
    }
    
    // We don't have a device or local file request, load it in the main Safari browser.
    else {
		DLog(@"Unknown URL %@",[url description]);
        [[UIApplication sharedApplication] openURL:url];
        return NO;
	}
	
	return YES;
}


/*
 * Fail Loading With Error
 * Error - If the webpage failed to load display an error with the reson.
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    ALog(@"Failed to load webpage with error: %@", [error localizedDescription]);
}


#pragma mark -
#pragma mark Helpers

/*
* Cleans up a JSON string 
*/
- (NSMutableString*)cleanupJSON:(NSMutableString *)s {
	GLog();
	
	// convert string to object "{'property':'value}"
	[s setString:[s stringByReplacingOccurrencesOfString:@"\"{" withString:@"{"]];
	[s setString:[s stringByReplacingOccurrencesOfString:@"}\"" withString:@"}"]];
	
	// convert objective c booleans
	[s setString:[s stringByReplacingOccurrencesOfString:@"\"YES\"" withString:@"true"]];
	[s setString:[s stringByReplacingOccurrencesOfString:@"\"NO\"" withString:@"false"]];

	
	// result
	return s;
}

	

#pragma mark -
#pragma mark Methodic Methods


/*
 * Device properties.
 */
- (NSDictionary*) deviceProperties {
	GLog();
	
	// info
	NSString *type = @"";
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)	{
		// ipad
		type = [type stringByAppendingString:@"iPad"];
	}
	else {
		// iphone
		type = [type stringByAppendingString:@"iPhone"];
	}
	
	// device
	UIDevice *device = [UIDevice currentDevice];
    NSMutableDictionary *devProps = [NSMutableDictionary dictionaryWithCapacity:8];
	[devProps setObject:type forKey:@"type"];
    [devProps setObject:[device model] forKey:@"platform"];
    [devProps setObject:[device systemVersion] forKey:@"version"];
	[devProps setObject:[device name] forKey:@"name"];
    [devProps setObject:[device uniqueIdentifier] forKey:@"uuid"];
	[devProps setObject:[NSString stringWithFormat:@"%f",self.webView.frame.size.width] forKey:@"view_width"];
	[devProps setObject:[NSString stringWithFormat:@"%f",self.webView.frame.size.height] forKey:@"view_height"];
	
	// return dict
    NSDictionary *devReturn = [NSDictionary dictionaryWithDictionary:devProps];
    return devReturn;
}

/*
 * User defaults.
 */
- (NSDictionary*) userDefaults {
	GLog();
	
	// defaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	// return dict
    NSDictionary *defaultsReturn = [NSDictionary dictionaryWithDictionary:[userDefaults dictionaryRepresentation]];
    return defaultsReturn;
}


/*
 * Resource.
 */
- (NSString*) pathForResource:(NSString*)resourcepath {
	GLog();

	// bundle
    NSBundle * mainBundle = [NSBundle mainBundle];
    NSMutableArray *directoryParts = [NSMutableArray arrayWithArray:[resourcepath componentsSeparatedByString:@"/"]];
    NSString       *filename       = [directoryParts lastObject];
    [directoryParts removeLastObject];
	
	// directory
    NSString *directoryStr = [NSString stringWithFormat:@"www/%@", [directoryParts componentsJoinedByString:@"/"]];
    return [mainBundle pathForResource:filename
								ofType:@""
						   inDirectory:directoryStr];
}


#pragma mark -
#pragma mark Commands

/*
* Executes a command.
*/
- (void)exec:(NSURL *)url {

	// parse
	NSString *surl = [url absoluteString];
	NSString *command = [url host];
	int s = [command length]+7;
	int e = [surl length]-s;
	NSString *data = [[surl substringWithRange:NSMakeRange(s,e)] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

	
	// execute
	if ([command isEqualToString:@"log"]) {
		[self log:data];
	}
	else if ([command isEqualToString:@"acceleration"]) {
		[self acceleration:data];
	}
}

/*
 * Alert.
 */
- (void)javascriptAlert:(NSString*)text {
	NSString* jsString = nil;
	jsString = [[NSString alloc] initWithFormat:@"alert('%@');", text];
	[webView stringByEvaluatingJavaScriptFromString:jsString];
	[jsString release];
}

/*
* Log.
*/
- (void)log:(NSString *)msg {
	DLog(@"%@",msg);
}

/*
* Device Acceleration.
*/
- (void)acceleration:(NSString *)dir {
	GLog(@"%@",dir);
	
	// always in motion
	DeviceAcceleration *deviceAcceleration = [deviceMotion currentAccelerometerData];
	
	// return it
	NSMutableString *result = [[NSMutableString alloc] initWithFormat:@"DeviceAcceleration = {'available':true,'x':'%f','y':'%f','z':'%f'}",deviceAcceleration.x,deviceAcceleration.y,deviceAcceleration.z];

	// eval
	[webView stringByEvaluatingJavaScriptFromString:result];
	[result release];
}



#pragma mark -
#pragma mark Memory Management


/*
 * Deallocates all used memory.
 */
- (void)dealloc {	
	GLog();
	
	// release
	[webView release];
	
	// superduper
	[super dealloc];
}




@end
