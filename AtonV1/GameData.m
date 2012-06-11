//
//  GameData.m
//  AtonV1
//
//  Created by Wen Lin on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameData.h"

@implementation GameData
@synthesize randomNum, str;

- (id)initWithPara:(NSNumber *)num :(NSString *)string
{
    if (self) {
        // Custom initialization
        randomNum = num;
        str = string;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        randomNum = [decoder decodeObjectForKey:@"randomNum"];
        str  = [decoder decodeObjectForKey:@"str"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:randomNum forKey:@"randomNum"];
    [encoder encodeObject:str forKey:@"str"];
}

@end
