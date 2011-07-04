//
//  Default.h
//  P5P
//
//  Created by CNPP on 26.2.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Sketch;

@interface Default :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) Sketch * sketch;

@end



