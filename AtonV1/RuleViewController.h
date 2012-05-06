//
//  RuleViewController.h
//  AtonV1
//
//  Created by Wen Lin on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RuleViewController;

@protocol RuleViewDelegate
-(void)dismissRuleViewWithAnimation:(RuleViewController*) subController;
-(void)dismissRuleViewWithoutAnimation:(RuleViewController*) subController;
@end

@interface RuleViewController : UIViewController {
    __unsafe_unretained id delegateRuleView;
    UIScrollView *scrollView;
}

-(IBAction) backToMenu:(id)sender;

@property (nonatomic, assign) id<RuleViewDelegate> delegateRuleView;

@end
