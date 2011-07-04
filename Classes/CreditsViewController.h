//
//  CreditsViewController.h
//  P5P
//
//  Created by CNPP on 25.2.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellLink.h"

//  Sections
enum {
    SectionCreditsReferences,
	SectionCreditsFrameworks,
	SectionCreditsComponents,
	SectionCreditsAssets
} P5PCreditsSections;



/**
 * Credit.
 */
@interface Credit : NSObject {

}

// Properties
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *meta;
@property (nonatomic, retain) NSString *url;

// Initializer
- (id)initWithName:(NSString*)n meta:(NSString*)m url:(NSString*)u;

@end


/**
* CreditsViewController.
*/
@interface CreditsViewController : UITableViewController <CellLinkDelegate> {
	
	// data
	NSMutableArray *references;
	NSMutableArray *frameworks;
	NSMutableArray *components;
	NSMutableArray *assets;
}

@end
