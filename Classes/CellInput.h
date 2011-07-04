//
//  CellInput.h
//  P5P
//
//  Created by CNPP on 3.3.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
#import <UIKit/UIKit.h>


/**
* Abstract CellInput.
*/
@interface CellInput : UITableViewCell {

	// data
	NSString *key;

}

// Properties
@property (nonatomic, retain) NSString *key;

// Business
- (void)update:(BOOL)reset;

@end
