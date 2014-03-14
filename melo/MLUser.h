//
//  MLUser.h
//  melo
//
//  Created by 新保 麻粋 on 2014/03/13.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MLUser : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSSet *items;
@property (nonatomic, retain) NSSet *follows;
@property (nonatomic, retain) NSSet *followers;

@property (nonatomic) BOOL isFollowed;
@property (nonatomic) BOOL isFollow;

- (MLUser *)update:(NSDictionary *)attributes;
@end

@interface MLUser (CoreDataGeneratedAccessors)

- (void)addItemsObject:(NSManagedObject *)value;
- (void)removeItemsObject:(NSManagedObject *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

- (void)addFollowsObject:(MLUser *)value;
- (void)removeFollowsObject:(MLUser *)value;
- (void)addFollows:(NSSet *)values;
- (void)removeFollows:(NSSet *)values;

- (void)addFollowersObject:(MLUser *)value;
- (void)removeFollowersObject:(MLUser *)value;
- (void)addFollowers:(NSSet *)values;
- (void)removeFollowers:(NSSet *)values;

@end
