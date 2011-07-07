//
//  Sketch.h
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

@class Collection;
@class Default;
@class SettingGroup;

@interface Sketch :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * sketch;
@property (nonatomic, retain) NSNumber * sort;
@property (nonatomic, retain) NSString * thumb;
@property (nonatomic, retain) NSString * sid;
@property (nonatomic, retain) NSString * meta;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* settingGroups;
@property (nonatomic, retain) Collection * collection;
@property (nonatomic, retain) NSSet* defaults;

@end


@interface Sketch (CoreDataGeneratedAccessors)
- (void)addSettingGroupsObject:(SettingGroup *)value;
- (void)removeSettingGroupsObject:(SettingGroup *)value;
- (void)addSettingGroups:(NSSet *)value;
- (void)removeSettingGroups:(NSSet *)value;

- (void)addDefaultsObject:(Default *)value;
- (void)removeDefaultsObject:(Default *)value;
- (void)addDefaults:(NSSet *)value;
- (void)removeDefaults:(NSSet *)value;

@end

