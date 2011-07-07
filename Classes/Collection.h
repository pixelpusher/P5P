//
//  Collection.h
//  P5P
//
//  Created by CNPP on 26.2.2011.
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

