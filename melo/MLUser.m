//
//  MLUser.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/13.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLUser.h"

@implementation MLUser

@dynamic id;
@dynamic name;
@dynamic image;
@dynamic items;
@dynamic follows;
@dynamic followers;
@dynamic enableSave;

@synthesize isFollowed;
@synthesize isFollow;

#pragma mark - Validate

- (BOOL)validateEnableSave:(id *)ioValue error:(NSError **)outError {
    if (*ioValue == nil || ![*ioValue boolValue]) {
        return NO;
    }
    return YES;
}

#pragma mark - Update

- (MLUser *)update:(NSDictionary *)attributes {
    self.id = attributes[@"id"];
    self.name = attributes[@"name"];
    if ([attributes[@"avatar"] class] != [NSNull class]) {
        self.image = attributes[@"avatar"];
    }
    //self.image = attributes[@"avatar"];
    return self;
}

@end
