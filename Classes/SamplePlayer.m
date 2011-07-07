//
//  SamplePlayer.m
//  P5P
//
//  Created by CNPP on 17.3.2011.
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
