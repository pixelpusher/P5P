//
//  Sketch.h
//  P5P
//
//  Created by CNPP on 26.2.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

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

