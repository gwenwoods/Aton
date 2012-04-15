//
//  AtonPlayer.h
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AtonPlayer : NSObject {
    
    CGPoint *startOriginArray, *endOriginArray;
}

-(id)initializeWithParameters:(int) thisPlayerEnum:(NSString*) name:(UIViewController*) controller;
-(void) displayStartCards;

@property (strong, nonatomic) UIView *baseView;
@property (nonatomic) int playerEnum;
@property (strong, nonatomic) NSString *playerName;
@property (nonatomic) int score;
@property (nonatomic) int *startCardNumArray, *endCardNumArray;
@property (strong, nonatomic) NSMutableArray *startCardIVArray, *endCardIVArray;

@end
