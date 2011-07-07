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