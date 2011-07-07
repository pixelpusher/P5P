//
//  DeviceMotion.m
//  P5P
//
//  Created by CNPP on 3.2.2011.
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

#import "DeviceMotion.h"

// constants
static const double kMinCutoffFrequency = 1;
static const double kUserAccelerationHpfCutoffFrequency = 1000.0;
static const double kUserAccelerationLpfCutoffFrequency = 10.0;


/**
* Device Motion.
*/
@implementation DeviceMotion

#pragma mark -
#pragma mark Properties

// accessors
@synthesize gravity;


#pragma mark -
#pragma mark Object Methods

/*
 * Init.
 */
-(id)init {
	FLog();
	
	// init 
    if (self = [super init]) { 
	
		// type
		self.gravity = YES;
		
		// motion manager
		motionManager = [[CMMotionManager alloc] init];
		motionManager.accelerometerUpdateInterval = 0.01; // 100Hz
		[motionManager startAccelerometerUpdates];
		
		// filters
		gravityLpf = [[LowpassFilter alloc] initWithCutoffFrequency:kMinCutoffFrequency];
		userAccelerationHpf = [[HighpassFilter alloc] initWithCutoffFrequency:kUserAccelerationHpfCutoffFrequency];
		userAccelerationHpfLpf = [[LowpassFilter alloc] initWithCutoffFrequency:kUserAccelerationLpfCutoffFrequency];
		
    }
	return self;
}



#pragma mark -
#pragma mark Business Methods

/**
* Retrieves the current accelerometer data.
*/
- (DeviceAcceleration*)currentAccelerometerData {
	
	// raw data
	CMAccelerometerData *accel = motionManager.accelerometerData;
	
	// Use a low-pass filter to isolate gravity
	[gravityLpf addAcceleration:accel.acceleration withTimestamp:accel.timestamp];

	 // Use a high-pass filter to isolate user acceleration
	[userAccelerationHpf addAcceleration:accel.acceleration withTimestamp:accel.timestamp];
		
	// The high-pass filtered user acceleration will be very noisy, so we send its output
	// through a low-pass filter to smooth it a bit
	CMAcceleration hpf = {userAccelerationHpf.x, userAccelerationHpf.y, userAccelerationHpf.z};
	[userAccelerationHpfLpf addAcceleration:hpf withTimestamp:accel.timestamp];
	
	
	// gravity
	if (gravity) {
		userAcceleration.x = gravityLpf.x;
		userAcceleration.y = gravityLpf.y;
		userAcceleration.z = gravityLpf.z;
	}
	// user
	else {
		// The user acceleration we want to use is the one computed by userAccelerationHpfLpf
		userAcceleration.x = userAccelerationHpfLpf.x;
		userAcceleration.y = userAccelerationHpfLpf.y;
		userAcceleration.z = userAccelerationHpfLpf.z;
	}

	GLog(@"user acceleration: x = %f,  y = %f, z = %f",userAcceleration.x,userAcceleration.y,userAcceleration.z);
	
	// return
	DeviceAcceleration *da = [[DeviceAcceleration alloc] init];
	da.x = userAcceleration.x;
	da.y = userAcceleration.y;
	da.z = userAcceleration.z;
	return da;
}



#pragma mark -
#pragma mark Memory management

/*
 * Deallocates all used memory.
 */
- (void)dealloc {
	GLog();
	
	// self
	[motionManager stopAccelerometerUpdates];
	[motionManager release];
	motionManager = nil;
	
	// super
    [super dealloc];
}


@end



/**
 * DeviceAcceleration data.
 */
@implementation DeviceAcceleration

#pragma mark -
#pragma mark Properties

// accessors
@synthesize x;
@synthesize y;
@synthesize z;


@end
