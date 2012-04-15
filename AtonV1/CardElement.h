//
//  CardElement.h
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CardElement : NSObject {
}

-(id)initializeWithParameters:(UIImageView*) imageView:(int) cardNumber:(int) index;
-(void) taken;

@property(strong, nonatomic) UIImageView *iv, *subIV;
@property(nonatomic) int number;

// location index are: 1,2,3,4 and 5
@property(nonatomic) int locationIndex;

@end
