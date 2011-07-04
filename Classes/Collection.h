//
//  Collection.h
//  P5P
//
//  Created by CNPP on 26.2.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Sketch;

@interface Collection :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * sort;
@property (nonatomic, retain) NSString * meta;
@property (nonatomic, retain) NSString * thumb;
@property (nonatomic, retain) NSString * lib;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * cid;
@property (nonatomic, retain) NSSet* sketches;

@end


@interface Collection (CoreDataGeneratedAccessors)
- (void)addSketchesObject:(Sketch *)value;
- (void)removeSketchesObject:(Sketch *)value;
- (void)addSketches:(NSSet *)value;
- (void)removeSketches:(NSSet *)value;

@end

