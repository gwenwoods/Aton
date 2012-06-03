//
//  RuleViewController.h
//  AtonV1
//
//  Created by Wen Lin on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

@class RuleView1Controller;

@protocol RuleView1Delegate
-(void)dismissRuleViewWithAnimation:(RuleView1Controller*) subController;
-(void)dismissRuleViewWithoutAnimation:(RuleView1Controller*) subController;
@end

@interface RuleView1Controller : UIViewController {
    __unsafe_unretained id delegateRuleView;
    UIScrollView *scrollView;
    UIImageView *iv;
    int pageIndex;
    AVAudioPlayer *audioFlip;
}

-(IBAction) backToMenu:(id)sender;

@property (nonatomic, assign) id<RuleView1Delegate> delegateRuleView;

@end
