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
        // TODO : category化
        if ([MLUserDefaults getCurrentUserid]) {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MLUser"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", [MLUserDefaults getCurrentUserid]];
            [fetchRequest setPredicate:predicate];
            
            NSArray *results = [[NSManagedObjectContext contextForCurrentThread] executeFetchRequest:fetchRequest error:nil];
            
            if (results.count > 0) {
                _currentuser = [results objectAtIndex:0];
            }
        }
        if (!_currentuser) {
            _currentuser = [MLUser createEntity];
        }
    }
    return [_currentuser inContext:[NSManagedObjectContext contextForCurrentThread]];
}

+ (void)update:(NSDictionary *)attributes {
    [[self currentuser] update:attributes];
    _currentuser.enableSave = @(YES);
    [_currentuser.managedObjectContext save];
    if (_currentuser.id) {
        [MLUserDefaults setCurrentUserId:_currentuser.id];
    }
}

+ (NSString *)getUUID {
    return [MLUserDefaults getUUID];
}

+ (void)setUUID:(NSString *)UUID {
    [MLUserDefaults setUUID:UUID];
}

+ (NSInteger)state {
    if (![self getUUID]) {
        return MLUserStateNew;
    } else if (![MLUserDefaults getFinishedStartGuide]) {
        return MLUserStateSingup;
    } else {
        return MLUserStateLogin;
    }
}

@end
