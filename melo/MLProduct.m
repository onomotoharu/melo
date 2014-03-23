//
//  MLProduct.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/13.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLProduct.h"

#define MLProductImageSize @[@"original", @"full", @"thumbnail"]
#define MLProductImageForm @"jpg"
typedef enum {
    MLProductImageTypeOriginal = 0,
    MLProductImageTypeFull = 1,
    MLProductImageTypeThumbnail = 2,
} MLProductImageTypes;


@implementation MLProduct

@dynamic id;
@dynamic userId;
@dynamic name;
@dynamic price;
@dynamic brand;
@dynamic originalImage;
@dynamic fullImage;
@dynamic thumbnailImage;
@dynamic externalUrl;
@dynamic user;
@dynamic enableSave;

@synthesize isWant;

#pragma mark - Validate

- (BOOL)validateEnableSave:(id *)ioValue error:(NSError **)outError {
    if (*ioValue == nil || ![*ioValue boolValue]) {
        return NO;
    }
    return YES;
}

#pragma mark - Update

- (MLProduct *)update:(NSDictionary *)attributes {
    self.id    = attributes[@"id"];
    self.name  = attributes[@"name"];
    self.price = attributes[@"price"];
    if (attributes[@"store"] && [attributes[@"store"][@"name"] class] != [NSNull class]) {
        self.brand = attributes[@"store"][@"name"];
    }
    // TODO: fix
    for (NSDictionary *photo in attributes[@"photos"]) {
        NSString *imageUrl = photo[@"image_url"];
        if ([imageUrl rangeOfString:MLProductImageSize[MLProductImageTypeOriginal]].location != NSNotFound) { // origin
            self.originalImage = imageUrl;
        } else if ([imageUrl rangeOfString:MLProductImageSize[MLProductImageTypeFull]].location != NSNotFound) { // full
            self.fullImage = imageUrl;
        } else if ([imageUrl rangeOfString:MLProductImageSize[MLProductImageTypeThumbnail]].location != NSNotFound) { // thumbnail
            self.thumbnailImage = imageUrl;
        }
    }
    self.externalUrl = attributes[@"external_url"];
    self.isWant = [attributes[@"wanted"] boolValue];
    self.userId = attributes[@"user_id"];
    if (attributes[@"user"]) {
        MLUser *user = [MLUser createEntity];
        [user update:attributes[@"user"]];
        self.user = user;
    }
    
    return self;
}

@end
