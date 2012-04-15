//
//  AtonTouchElement.h
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardElement.h"

@interface AtonTouchElement : NSObject {
    
}

-(id)initializeWithParameters:(UIViewController*) controller;
-(void) takeCardElement:(CardElement*) ce;
-(void) reset;

@property(strong, nonatomic) UIView *baseView;
@property(strong, nonatomic) UIImageView *touchIV;
@property(nonatomic) int cardNum;
@property(nonatomic) int fromIndex;

@end
