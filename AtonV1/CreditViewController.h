//
//  CreditViewController.h
//  AtonV1
//
//  Created by Wen Lin on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CreditViewController;

@protocol CreditViewDelegate
-(void)dismissCreditViewWithAnimation:(CreditViewController*) subController;
-(void)dismissCreditViewWithoutAnimation:(CreditViewController*) subController;
@end

@interface CreditViewController : UIViewController {
    __unsafe_unretained id delegateCreditView;
}

//-(IBAction) backToMenu:(id)sender;

@property (nonatomic, assign) id<CreditViewDelegate> delegateCreditView; 

@end