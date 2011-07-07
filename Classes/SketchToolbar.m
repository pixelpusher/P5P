//
//  SketchToolbar.m
//  P5P
//
//  Created by CNPP on 7.7.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
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

#import "SketchToolbar.h"


/**
 * SketchToolbar.
 */
@implementation SketchToolbar


#pragma mark -
#pragma mark Object Methods

/*
 * Init.
 */
- (id) initWithFrame:(CGRect) frame {
    
    // self
	self = [super initWithFrame:frame];
    
    // properties
	self.opaque = NO;
	self.translucent = YES;
    self.barStyle = UIBarStyleBlackTranslucent;
    
    // background
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.72];
    
    // back to business
	return self;
}

#pragma mark -
#pragma mark UIView Methods

/*
 * Draw.
 */
- (void)drawRect:(CGRect)rect {
    // do nothing in here
}

@end
