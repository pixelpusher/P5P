//
//  TapDetectingWindow.m
//  P5P
//
//  Created by CNPP on 4.2.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
* Delegate.
*/
@protocol TapDetectingWindowDelegate
- (void)singleTap:(id)tapPoint;
- (void)doubleTap:(id)tapPoint;
@end

/*
* Tap Detecting Window.
* @source http://mithin.in/2009/08/26/detecting-taps-and-events-on-uiwebview-the-right-way
*/
@interface TapDetectingWindow : UIWindow {
    UIView *viewToObserve;
    id <TapDetectingWindowDelegate> controllerThatObserves;
}
@property (nonatomic, retain) UIView *viewToObserve;
@property (nonatomic, assign) id <TapDetectingWindowDelegate> controllerThatObserves;
@end