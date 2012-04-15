//
//  AtonTouchElement.h
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


//enum TOUCH_ELEMENT_ENUM {
//    TOUCH_ELEMENT_NONE, TOUCH_ELEMENT_CARD_1, TOUCH_ELEMENT_CARD_2
//};

@interface AtonTouchElement : NSObject {
    
}

-(id)initializeWithParameters:(UIViewController*) controller;
-(void) reset;

@property(nonatomic,retain) UIImageView* touchIV;
//@property(nonatomic) int touchElementEnum;
@property(nonatomic) int cardIndex;
@property(nonatomic) int cardNum;

@end
