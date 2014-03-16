//
//  MLCurrentUser.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/15.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLCurrentUser.h"

static MLUser *_currentuser = nil;

@implementation MLCurrentUser

+ (MLUser *)currentuser {
    if (!_currentuser) {
        _currentuser = [MLUser createEntity];
        _currentuser.id = @(1);
        _currentuser.name = @"Thubasa Honda";
        _currentuser.image = @"https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcRULOovkCAsYhHEtotiUh48CwXPGpaNUTJN04O800pKPKfh6L6h";
    }
    return _currentuser;
}
@end
