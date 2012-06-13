//
//  GameData.h
//  AtonV1
//
//  Created by Wen Lin on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameData : NSObject<NSCoding> {
    NSNumber *randomNum;
    NSString *str;

    NSNumber *gamePhaseEnum, *gameCenterStateEnum;
    NSNumber *senderEnum;
    NSMutableArray* cardNumArray;
    
    NSMutableArray *liteSlotArray;    
}

- (id)initWithPara:(NSNumber*) num:(NSString*) string;
- (id)initWithCardArray:(NSNumber*) gamePhase:(NSNumber*)sender:(NSMutableArray*) array;
- (id)initWithSlotArray:(NSNumber*) gamePhase:(NSNumber*)sender:(NSMutableArray*) array;

@property (nonatomic, strong) NSNumber *randomNum;
@property (nonatomic, strong) NSString *str;

@property (nonatomic) NSNumber *senderEnum, *gamePhaseEnum, *gameCenterStateEnum;
@property (nonatomic, strong) NSMutableArray* cardNumArray, *liteSlotArray;


@end
