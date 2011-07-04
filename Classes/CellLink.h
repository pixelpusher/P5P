//
//  CellLink.h
//  P5P
//
//  Created by CNPP on 25.2.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * CellLinkDelegate Protocol.
 */
@class CellLink;
@protocol CellLinkDelegate <NSObject>
	- (void)cellLinkSelected:(CellLink*)c;
@end


/**
* CellLink.
*/
@interface CellLink : UITableViewCell {

	// delegate
	id<CellLinkDelegate>delegate;
	
	// data
	NSString *url;
}

// Properties
@property (assign) id<CellLinkDelegate> delegate;
@property (nonatomic, retain) NSString *url;


@end
