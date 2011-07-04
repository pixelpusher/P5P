//
//  DeviceMotion.h
//  P5P
//
//  Created by CNPP on 3.2.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "AccelerometerFilter.h"

/**
 * DeviceAcceleration data.
 */
@interface DeviceAcceleration : NSObject {
	
	// fields
	double x;
	double y;
	double z;

}

// Properties
@property double x;
@property double y;
@property double z;

@end


/**
* Device Motion.
*/
@interface DeviceMotion : NSObject {

	// manager
	CMMotionManager *motionManager;
	
	// filters
	LowpassFilter *gravityLpf;
	HighpassFilter *userAccelerationHpf;
	LowpassFilter *userAccelerationHpfLpf;
	
	// processed data
	BOOL gravity;
	CMAcceleration userAcceleration;
	

}

// Properties
@property BOOL gravity;

// Business Methods
- (DeviceAcceleration*)currentAccelerometerData;


@end
