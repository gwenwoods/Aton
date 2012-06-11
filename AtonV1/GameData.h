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
}

- (id)initWithPara:(NSNumber *)num :(NSString *)string;

@property (nonatomic, strong) NSNumber *randomNum;
@property (nonatomic, strong) NSString *str;

@end
