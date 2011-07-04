//
//  Setting.h
//  P5P
//
//  Created by CNPP on 26.2.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <CoreData/CoreData.h>

@class SettingGroup;

@interface Setting :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * sort;
@property (nonatomic, retain) NSNumber * live;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * options;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) SettingGroup * settingGroup;

@end



