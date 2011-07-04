//
//  AccountTwitterViewController.h
//  P5P
//
//  Created by CNPP on 24.3.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TwitterAPI.h"

// Sections
enum {
	SectionAccountTwitter,
	SectionAccountTwitterAuthenticate
} P5PAccountTwitterSections;


/**
* AccountTwitterViewController.
*/
@interface AccountTwitterViewController : UITableViewController <TwitterAPIDelegate, UIAlertViewDelegate>  {

	// engine
	TwitterAPI *twitterAPI;
}

// Actions
- (void)actionConnectAccount:(id)sender;
- (void)actionRemoveAccount:(id)sender;


@end
