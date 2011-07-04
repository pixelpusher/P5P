//
//  SamplePlayer.m
//  P5P
//
//  Created by CNPP on 17.3.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "SamplePlayer.h"


/**
* Basic SamplePlayer.
*/
@implementation SamplePlayer


#pragma mark -
#pragma mark Accessors

// synthesize
@synthesize sampleSelected;


#pragma mark -
#pragma mark Object Methods

/*
* Initialize.
*/
- (id)init {

	// object
	if (self = [super init]) {
		
		// selected
		NSString *sampleSelectedPath = [[NSBundle mainBundle] pathForResource:@"sample_selected" ofType:@"wav"];
		CFURLRef sampleSelectedURL = (CFURLRef) [NSURL fileURLWithPath:sampleSelectedPath];
		AudioServicesCreateSystemSoundID(sampleSelectedURL, &sampleSelected);
	}
	
	// return
	return self;
}


#pragma mark -
#pragma mark Business Methods


/**
* Plays a sample.
*/
- (void)play:(NSInteger)sample {
	
	// sample
	switch (sample) {
		
		// selected
		case SampleSelected: {
			FLog(@"SampleSelected");
			AudioServicesPlaySystemSound(sampleSelected);
			break;
		}
		default:
			break;
	}
}

@end
