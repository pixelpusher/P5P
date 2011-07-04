//
//  ColorPageControl.m
//  Sensible Duck Ltd
//
//  Created by Simon Maddox on 23/2/10.
//  Copyright (c) 2010 Sensible Duck Ltd
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "ColorPageControl.h"


/**
* Color page control.
*/
@implementation ColorPageControl


#pragma mark -
#pragma mark Properties

// accessors
@synthesize numberOfPages, hidesForSinglePage, inactivePageColor, activePageColor;
@dynamic currentPage;


#pragma mark -
#pragma mark Object Methods

/*
* Init.
*/
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        hidesForSinglePage = NO;
    }
    return self;
}

/*
* Draw.
*/
- (void)drawRect:(CGRect)rect {
	
	// decide
	if (hidesForSinglePage == NO || [self numberOfPages] > 1){
	
		// defaults
		if (activePageColor == nil){
			activePageColor = [UIColor blackColor];
		}
		
		if (inactivePageColor == nil){
			inactivePageColor = [UIColor grayColor];
		}
		
		// vars
		CGContextRef context = UIGraphicsGetCurrentContext();
		float dotSize = self.frame.size.height / 6;		
		float dotsWidth = (dotSize * [self numberOfPages]) + (([self numberOfPages] - 1) * 10);
		float offset = (self.frame.size.width - dotsWidth) / 2;
		
		// draw dots
		for (NSInteger i = 0; i < [self numberOfPages]; i++){
			if (i == [self currentPage]){
				CGContextSetFillColorWithColor(context, [activePageColor CGColor]);
			} 
			else {
				CGContextSetFillColorWithColor(context, [inactivePageColor CGColor]);
			}
			
			CGContextFillEllipseInRect(context, CGRectMake(offset + (dotSize + 10) * i, (self.frame.size.height / 2) - (dotSize / 2), dotSize, dotSize));
		}
	}
}

#pragma mark -
#pragma mark Business Methods

/*
* Current.
*/
- (NSInteger) currentPage{
	return currentPage;
}

- (void) setCurrentPage:(NSInteger)page {
	currentPage = page;
	[self setNeedsDisplay];
}


#pragma mark -
#pragma mark Memory Management

/*
* Dealloc.
*/
- (void)dealloc {
    [super dealloc];
}


@end
