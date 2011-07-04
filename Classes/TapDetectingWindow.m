//
//  TapDetectingWindow.m
//  P5P
//
//  Created by CNPP on 4.2.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

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
