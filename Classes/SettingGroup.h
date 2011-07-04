//
//  SettingGroup.h
//  P5P
//
//  Created by CNPP on 26.2.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Setting;
@class Sketch;

@interface SettingGroup :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * gid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * sort;
@property (nonatomic, retain) Sketch * sketch;
@property (nonatomic, retain) NSSet* settings;

@end


@interface SettingGroup (CoreDataGeneratedAccessors)
- (void)addSettingsObject:(Setting *)value;
- (void)removeSettingsObject:(Setting *)value;
- (void)addSettings:(NSSet *)value;
- (void)removeSettings:(NSSet *)value;

@end

