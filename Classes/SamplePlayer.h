//
//  SamplePlayer.h
//  P5P
//
//  Created by CNPP on 17.3.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioServices.h>


//  Variables
enum {
    SampleSelected
} Samples;

/**
* Basic SamplePlayer.
*/
@interface SamplePlayer : NSObject {

	// samples
	SystemSoundID sampleSelected;
}

// Properties
@property (nonatomic) SystemSoundID sampleSelected;

// Business Methods
- (void)play:(NSInteger)sample;

@end
