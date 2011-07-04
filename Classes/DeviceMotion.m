//
//  DeviceMotion.m
//  P5P
//
//  Created by CNPP on 3.2.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

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
