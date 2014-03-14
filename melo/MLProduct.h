//
//  MLProduct.h
//  melo
//
//  Created by 新保 麻粋 on 2014/03/13.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MLUser;

@interface MLProduct : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * brand;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) MLUser *user;

@property (nonatomic) BOOL isWant;

- (MLProduct *)update:(NSDictionary *)attributes;
@end
