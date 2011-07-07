//
//  TapDetectingWindow.m
//  P5P
//
//  Created by CNPP on 4.2.2011.
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

#import "TapDetectingWindow.h"

/*
* Tap Detecting Window.
*/
@implementation TapDetectingWindow


#pragma mark -
#pragma mark Properties

// accessors
@synthesize viewToObserve;
@synthesize controllerThatObserves;

/*
* Init window.
*/
- (id)initWithViewToObserver:(UIView *)view andDelegate:(id)delegate {
    if(self == [super init]) {
        self.viewToObserve = view;
        self.controllerThatObserves = delegate;
    }
    return self;
}

/*
* Custom send event method.
*/
- (void)sendEvent:(UIEvent *)event {
	// super
    [super sendEvent:event];
	
	// custom 
	
	// nothing to observe
    if (viewToObserve == nil || controllerThatObserves == nil) {
        return;
	}

	
	// touches
    NSSet *touches = [event allTouches];
	
	// filter single touch
    if (touches.count != 1) {
        return; // no touches
	}
	
	// touch object
    UITouch *touch = touches.anyObject;
	
	// filter touch ended
    if (touch.phase != UITouchPhaseEnded) {
        //return;
	}
	
	// filter view
    if ([touch.view isDescendantOfView:viewToObserve] == NO) {
        return;
	}
	
	// we have touch
    CGPoint tapPoint = [touch locationInView:viewToObserve];
    GLog(@"TapPoint = %f, %f, count = %i", tapPoint.x, tapPoint.y, touch.tapCount);
	
	// tap 
    NSArray *pointArray = [NSArray arrayWithObjects:[NSNumber numberWithFloat:tapPoint.x],[NSNumber numberWithFloat:tapPoint.y], nil];
    if (touch.tapCount == 1 && touch.phase != UITouchPhaseEnded) {
        [self performSelector:@selector(forwardSingleTap:) withObject:pointArray afterDelay:0.3];
    }
	// tap tap
    else if (touch.tapCount > 1) {
		[NSObject cancelPreviousPerformRequestsWithTarget:self];
		[self performSelector:@selector(forwardDoubleTap:) withObject:pointArray];
    }


}

/*
* Forward tap.
*/
- (void)forwardSingleTap:(id)touch {
    [controllerThatObserves singleTap:touch];
}
- (void)forwardDoubleTap:(id)touch {
    [controllerThatObserves doubleTap:touch];
}


/*
* Release memory.
*/
- (void)dealloc {
    [viewToObserve release];
    [super dealloc];
}
@end
