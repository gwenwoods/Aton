//
//  AtonGameManager.h
//  AtonV1
//
//  Created by Wen Lin on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AtonGameManager : NSObject

-(id)initializeWithParameters:(UIView*) atonBaseView;

@property(strong, nonatomic) UIView* baseView;
@property(nonatomic) int activePlayer;
@property(strong, nonatomic) UIImageView *communicationView;

@end
