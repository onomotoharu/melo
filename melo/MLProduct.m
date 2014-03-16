//
//  MLProduct.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/13.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLProduct.h"

@implementation MLProduct

@dynamic id;
@dynamic userId;
@dynamic name;
@dynamic price;
@dynamic brand;
@dynamic image;
@dynamic user;

@synthesize isWant;

#pragma mark - Validate

- (BOOL)validateId:(id *)ioValue error:(NSError **)outError {
    if (*ioValue == nil || [*ioValue isEqualToNumber:@(0)]) {
        return NO;
    }
    return YES;
}

#pragma mark - Update

- (MLProduct *)update:(NSDictionary *)attributes {
    self.id = [attributes objectForKey:@"id"];
    self.name = [attributes objectForKey:@"name"];
    self.price = [attributes objectForKey:@"price"];
    self.brand = [attributes objectForKey:@"brand"];
    self.image = @"http://s3-ap-northeast-1.amazonaws.com/development-melo/product/photo/4/thumbnail.jpg";
    self.userId = [attributes objectForKey:@"user_id"];
    // TODO : set user
    
    return self;
}

@end
