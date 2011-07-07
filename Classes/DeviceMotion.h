//
//  DeviceMotion.h
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
