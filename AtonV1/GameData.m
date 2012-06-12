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
@synthesize senderEnum, gamePhaseEnum, cardNumArray;
@synthesize liteSlotArray;

- (id)initWithPara:(NSNumber *)num :(NSString *)string
{
    if (self) {
        // Custom initialization
        randomNum = num;
        str = string;
    }
    return self;
}

- (id)initWithCardArray:(NSNumber*) gamePhase:(NSNumber*)sender:(NSMutableArray*) array
{
    if (self) {
        // Custom initialization
        gamePhaseEnum = gamePhase;
        senderEnum = sender;
        cardNumArray = [[NSMutableArray alloc] init];
        [cardNumArray addObjectsFromArray:array];
    }
    return self;
}

- (id)initWithSlotArray:(NSNumber*) gamePhase:(NSNumber*)sender:(NSMutableArray*) array
{
    if (self) {
        // Custom initialization
        gamePhaseEnum = gamePhase;
        senderEnum = sender;
        liteSlotArray = [[NSMutableArray alloc] init];
        [liteSlotArray addObjectsFromArray:array];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        randomNum = [decoder decodeObjectForKey:@"randomNum"];
        str  = [decoder decodeObjectForKey:@"str"];
        
        gamePhaseEnum = [decoder decodeObjectForKey:@"gamePhaseEnum"];
        senderEnum = [decoder decodeObjectForKey:@"senderEnum"];
        cardNumArray = [decoder decodeObjectForKey:@"cardNumArray"];
        liteSlotArray = [decoder decodeObjectForKey:@"liteSlotArray"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:randomNum forKey:@"randomNum"];
    [encoder encodeObject:str forKey:@"str"];
    
    [encoder encodeObject:gamePhaseEnum forKey:@"gamePhaseEnum"];
    [encoder encodeObject:senderEnum forKey:@"senderEnum"];
    [encoder encodeObject:cardNumArray forKey:@"cardNumArray"];
    [encoder encodeObject:liteSlotArray forKey:@"liteSlotArray"];
}

@end
