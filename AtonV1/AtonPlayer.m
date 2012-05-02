//
//  AtonPlayer.m
//  AtonV1
//
//  Created by Wen Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonPlayer.h"

@implementation AtonPlayer

static int CARD_WIDTH = 88;
static int CARD_HEIGHT = 134;

static int START_SPACE = 821;

static NSString *redCardNames[4] = {@"Red_Card1",@"Red_Card2",@"Red_Card3",@"Red_Card4"};
static NSString *blueCardNames[4] = {@"Blue_Card1",@"Blue_Card2",@"Blue_Card3",@"Blue_Card4"};

static int CARD_NUM = 40;

static float DELAY_TIME = 0.25;

@synthesize controller, baseView;
@synthesize playerEnum, playerName;
@synthesize score;
@synthesize cardElementArray, emptyCardElementArray, tempCardElementArray;
@synthesize deckIV, deckAnimationIV, deckArray, menuView;
@synthesize exchangeCardsButton;

-(id)initializeWithParameters:(int) thisPlayerEnum:(NSString*) name:(UIViewController*) viewController {
	if (self) {
        controller = viewController;
        baseView = controller.view;
        playerEnum = thisPlayerEnum;
        playerName = name;
        
        //--------------
        // menu
        menuView = [[UIImageView alloc] initWithFrame:CGRectMake(playerEnum *972.0, 0, 52, 640)];
        [menuView setBackgroundColor:[UIColor whiteColor]];
        menuView.hidden = YES;
        menuView.userInteractionEnabled = YES;
        [baseView addSubview:menuView];
        
        actionLb = [[UILabel alloc] initWithFrame:CGRectMake(2, 340, 50, 20)];
        actionLb.text = @"Remove";
        actionLb.font = [UIFont systemFontOfSize:12];
        [menuView addSubview:actionLb];
        
        doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        doneButton.frame = CGRectMake(4,560, 40, 50);
        doneButton.userInteractionEnabled = YES;
        [doneButton setTitle:@"Done"  forState:UIControlStateNormal];
        [doneButton addTarget:controller action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:doneButton];
        
        UIImageView *p0 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 380, 36, 36)];
     //   p0.image = [UIImage imageNamed:@"Red_Disc"];
        UIImageView *p1 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 420, 36, 36)];
    //    p1.image = [UIImage imageNamed:@"Red_Disc"];
        UIImageView *p2 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 460, 36, 36)];
      //  p2.image = [UIImage imageNamed:@"Red_Disc"];
        UIImageView *p3 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 500, 36, 36)];
     //   p3.image = [UIImage imageNamed:@"Red_Disc"];
        [menuView addSubview:p0];
        [menuView addSubview:p1];
        [menuView addSubview:p2];
        [menuView addSubview:p3];
        menuPeepArray = [[NSMutableArray alloc] init];
        [menuPeepArray addObject:p0];
        [menuPeepArray addObject:p1];
        [menuPeepArray addObject:p2];
        [menuPeepArray addObject:p3];
        [menuView setBackgroundColor:[UIColor whiteColor]];
        //--------
        startOriginArray = (CGPoint*)malloc(sizeof(CGPoint) * 4);
        startOriginArray[0] =  CGPointMake(58.0 + thisPlayerEnum * START_SPACE, 82.0);
        startOriginArray[1] =  CGPointMake(58.0 + thisPlayerEnum * START_SPACE, 251.0);
        startOriginArray[2] =  CGPointMake(58.0 + thisPlayerEnum * START_SPACE, 420.0);
        startOriginArray[3] =  CGPointMake(58.0 + thisPlayerEnum * START_SPACE, 589.0);
        
        cardElementArray = [[NSMutableArray alloc] init];
        for (int i=0; i<4; i++) {
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(startOriginArray[i].x, startOriginArray[i].y, CARD_WIDTH, CARD_HEIGHT)];
            [baseView addSubview:iv];
            
            CardElement *ce = [[CardElement alloc] initializeWithParameters:iv:0:(i+1)];
            ce.iv.hidden = YES;
            [cardElementArray addObject:ce];
        }
        
        emptyCardElementArray = [[NSMutableArray alloc] init];
        for (int i=0; i<4; i++) {
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(-200, -200, CARD_WIDTH, CARD_HEIGHT)];
            iv.image = nil;
            [baseView addSubview:iv];
            
            CardElement *ce = [[CardElement alloc] initializeWithParameters:iv:0:5];
            [emptyCardElementArray addObject:ce];
        }

        tempCardElementArray = [[NSMutableArray alloc] init];
        [self initilizeDeck];
    }  
    return self;
}


-(void) initilizeDeck {
    
    deckCountLb = [[UILabel alloc] initWithFrame:CGRectMake(118 + playerEnum * START_SPACE,56,30,20)];
    deckCountLb.backgroundColor = [UIColor clearColor];
    deckCountLb.textAlignment = UITextAlignmentCenter;
    deckCountLb.lineBreakMode = UILineBreakModeCharacterWrap;
    deckCountLb.numberOfLines = 3;     
    deckCountLb.textColor = [UIColor whiteColor];
    deckCountLb.text = @"x40";
   // deckCountLb.font = [UIFont fontWithName:@"Copperplate" size:24];
    [baseView addSubview:deckCountLb];
    [baseView bringSubviewToFront:deckCountLb];

     
    exchangeCardsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    exchangeCardsButton.frame = CGRectMake(11 + playerEnum * (START_SPACE + 139) , 8, 40, 50);
    exchangeCardsButton.userInteractionEnabled = NO;
    [exchangeCardsButton setImage:[UIImage imageNamed:@"White_Cylinder.png"]  forState:UIControlStateNormal];
    [exchangeCardsButton addTarget:controller action:@selector(exchangeCards:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:exchangeCardsButton];
    
    deckIV = [[UIImageView alloc] initWithFrame:CGRectMake(56 + playerEnum * START_SPACE, 2, 90, 56)];
    deckIV.image = [UIImage imageNamed:[self getDeckBackName]];
    [baseView addSubview:deckIV];
    
    deckAnimationIV = [[UIImageView alloc] initWithFrame:CGRectMake(56 + playerEnum * START_SPACE, 10, 32, 48)];
    deckAnimationIV.image = [UIImage imageNamed:[self getCardBackName]];
    deckAnimationIV.hidden = YES;
    [baseView addSubview:deckAnimationIV];
    
    deckArray = [self initializeDeckArray];
  /*  int *deckNumberArray = malloc(sizeof(int) * CARD_NUM);
    for (int i=0; i<CARD_NUM; i++) {
        deckNumberArray[i] = i%4 + 1;
    }
    
    //------------------------------
    int n = (time(0) + playerEnum *7 )%100;
    srand(time(0) + playerEnum *7);
    
    for (int count = 0; count < n; count++) {
        for (int i=0; i<(CARD_NUM-1); i++) {
            int r = i + (rand() % (CARD_NUM-i)); // Random remaining position.
            int temp = deckNumberArray[i]; 
            deckNumberArray[i] = deckNumberArray[r]; 
            deckNumberArray[r] = temp;
        }
    }
    
    deckArray = [[NSMutableArray alloc] init];
    for (int i=0; i< CARD_NUM; i++) {
        int number = deckNumberArray[i];
        [deckArray addObject:[NSNumber numberWithInt:number]];
    }*/
}

-(void) distributeCards {
    
    if ([deckArray count] == 0) {
        deckArray = [self initializeDeckArray];
    }
    for (int i=0; i<4; i++) {
        CardElement *targetCE = [cardElementArray objectAtIndex:i];
        //targetCE.number = i +1;
        int number = [[deckArray objectAtIndex:0] intValue];
        [deckArray removeObjectAtIndex:0];
        targetCE.number = number;
        targetCE.iv.image = [UIImage imageNamed:[self getCardName:targetCE.number]];
        [self performSelector:@selector(distributeCardFromDeck:) withObject:targetCE.iv afterDelay:i*0.5 + DELAY_TIME];
       // [self ivTravel:deckIV:targetCE.iv];
    }
    
    NSString *msg = @"x";
    int deckNum = [deckArray count];
    msg = [msg stringByAppendingString:[NSString stringWithFormat:@"%i", deckNum]];
    deckCountLb.text = msg;

}

-(NSString*) getCardBackName {
    
    if(playerEnum == 0) {
        return @"Red_CardBack.png";
    } else {
        return @"Blue_CardBack.png";
    }
}

-(NSString*) getDeckBackName {
    
    if(playerEnum == 0) {
        return @"Red_CardBack_stack.png";
    } else {
        return @"Blue_CardBack_stack.png";
    }
}

-(NSString*) getCardName: (int) cardNum {
    
    if (playerEnum == 0) {
        return redCardNames[cardNum-1];
    } else {
        return blueCardNames[cardNum-1];
    }
}

-(void) switchCardElement:(AtonTouchElement*) touchElement:(CardElement*) targetCE {
    
    int fromIndex = touchElement.fromIndex;
    CardElement *fromCE = [cardElementArray objectAtIndex:(fromIndex-1)];
    fromCE.number = targetCE.number;
    UIImageView *animationIV = [[UIImageView alloc] initWithFrame:targetCE.iv.frame];
    animationIV.image = targetCE.iv.image;
    targetCE.iv.image = nil;

    [baseView addSubview:animationIV];
   // [baseView bringSubviewToFront:animationIV];
   // [baseView bringSubviewToFront:[touchElement touchIV]];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         animationIV.frame = fromCE.iv.frame;
                         animationIV.center = fromCE.iv.center;
                     } 
                     completion:^(BOOL finished){
                         //fromIV.image = nil;
                         fromCE.iv.image = animationIV.image;
                         [animationIV removeFromSuperview];
                         
                         if(fromCE.iv.image != nil) {
                             fromCE.subIV.hidden = YES;
                         }
                     }];

    
 //   fromCE.iv.image = targetCE.iv.image;
 //   fromCE.number = targetCE.number;
 //   if(fromCE.iv.image != nil) {
 //       fromCE.subIV.hidden = YES;
 //   }
    
    UIImageView *animationIV1 = [[UIImageView alloc] initWithFrame:touchElement.touchIV.frame];
    animationIV1.image =  touchElement.touchIV.image;
    targetCE.number = [touchElement cardNum];
    [touchElement reset];
    [baseView addSubview:animationIV1];    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         animationIV1.frame = targetCE.iv.frame;
                         animationIV1.center = targetCE.iv.center;
                     } 
                     completion:^(BOOL finished){
                         //fromIV.image = nil;
                         targetCE.iv.image = animationIV1.image;
                         [animationIV1 removeFromSuperview];
                         
                         targetCE.subIV.hidden = YES;
                         
                         [baseView bringSubviewToFront:fromCE.iv];
                         [baseView bringSubviewToFront:targetCE.iv];
                         [baseView bringSubviewToFront:[touchElement touchIV]];
                        
                     }];

    
//    targetCE.iv.image = touchElement.touchIV.image;
//    targetCE.subIV.hidden = YES;
//    targetCE.number = [touchElement cardNum];

    
//    [baseView bringSubviewToFront:fromCE.iv];
//    [baseView bringSubviewToFront:targetCE.iv];
//    [touchElement reset];
}

-(void) placeTempCardElementFromTouch:(AtonTouchElement*) touchElement {

    CardElement *ce = [emptyCardElementArray objectAtIndex:0];
    ce.number = touchElement.cardNum;
    ce.iv.image = touchElement.touchIV.image;
    ce.iv.center = touchElement.touchIV.center;
    [baseView bringSubviewToFront:ce.iv];
    
    [emptyCardElementArray removeObjectAtIndex:0];
    [tempCardElementArray addObject:ce];
    [touchElement reset];
}

-(void) releaseTempCardElement:(CardElement*) ce {
    [tempCardElementArray removeObject:ce];
    ce.iv.image = nil;
    ce.iv.center = CGPointMake(-200,-200);
    ce.number = 0;
    [emptyCardElementArray addObject:ce];
}

-(void) pushTargetToTemp:(CardElement*) targetCE {
    CardElement *tempCE= [emptyCardElementArray objectAtIndex:0];
    tempCE.number = targetCE.number;
    int count = [self findNumTempCardsAtCurrentRight:targetCE];
    int pushSpace = 100 + count*28;
    if (playerEnum ==1) {
        pushSpace = pushSpace*(-1);
    }
    CGPoint tempCenter = CGPointMake(targetCE.iv.center.x + pushSpace, targetCE.iv.center.y);
    tempCE.iv.center = tempCenter;
  //  tempCE.iv.image = targetCE.iv.image;
    [baseView bringSubviewToFront:tempCE.iv];
    
    [emptyCardElementArray removeObject:tempCE];
    [tempCardElementArray addObject:tempCE];
    
    [self ivTravel:targetCE.iv :tempCE.iv];
}

-(void) placeCardElementFromTouch:(AtonTouchElement*) touchElement:(CardElement*) targetCE {
    //targetCE.iv.image = touchElement.touchIV.image;
  //  targetCE.subIV.hidden = YES;
   // targetCE.number = [touchElement cardNum];
  //  [touchElement reset];
    
    UIImageView *animationIV = [[UIImageView alloc] initWithFrame:touchElement.touchIV.frame];
    animationIV.image =  touchElement.touchIV.image;
    targetCE.number = [touchElement cardNum];
    [touchElement reset];
    [baseView addSubview:animationIV];    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         animationIV.frame = targetCE.iv.frame;
                         animationIV.center = targetCE.iv.center;
                     } 
                     completion:^(BOOL finished){
                         //fromIV.image = nil;
                         targetCE.iv.image = animationIV.image;
                         [animationIV removeFromSuperview];
                         
                         targetCE.subIV.hidden = YES;
                         
                        // [baseView bringSubviewToFront:fromCE.iv];
                         [baseView bringSubviewToFront:targetCE.iv];
                         [baseView bringSubviewToFront:[touchElement touchIV]];
                         
                     }];
}

-(int) findNumTempCardsAtCurrentRight:(CardElement*) targetCE {
    int count = 0;
    int currentY = targetCE.iv.center.y;
    for (int i=0; i<[tempCardElementArray count]; i++) {
        CardElement* tmpElement = [tempCardElementArray objectAtIndex:i];
        if (tmpElement.iv.center.y == currentY) {
            count ++;
        }
    }
    return count;
}

-(void) ivTravel:(UIImageView*) fromIV:(UIImageView*) toIV {
    
    UIImageView *animationIV = [[UIImageView alloc] initWithFrame:fromIV.frame];
    animationIV.image = fromIV.image;
    fromIV.image = nil;
    
    [baseView addSubview:animationIV];    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         animationIV.frame = toIV.frame;
                         animationIV.center = toIV.center;
                     } 
                     completion:^(BOOL finished){
                         //fromIV.image = nil;
                         toIV.image = animationIV.image;
                         [animationIV removeFromSuperview];
                     }];
}

-(void) distributeCardFromDeck:(UIImageView*) toIV {
    UIImageView *animationIV = [[UIImageView alloc] initWithFrame:deckAnimationIV.frame];
    animationIV.image = deckAnimationIV.image;
    
    [baseView addSubview:animationIV];    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         animationIV.frame = toIV.frame;
                         animationIV.center = toIV.center;
                     } 
                     completion:^(BOOL finished){
                         //fromIV.image = nil;
                         toIV.image = animationIV.image;
                         toIV.hidden = NO;
                         [animationIV removeFromSuperview];
                     }];

}

-(void) openCardsForArrange {
    [self openCards];
    [self performSelector:@selector(enablePlayerArrangeCards) withObject:nil afterDelay:0.6];
}
 
-(void) openCards {
    for (int i=0; i<4; i++) {
        CardElement *ce = [cardElementArray objectAtIndex:i];
        NSString *imgName = [self getCardName:ce.number];
        [self flipIV:ce.iv withImgName:imgName];
    }
}

-(void) closeCards {
    for (int i=0; i<4; i++) {
        CardElement *ce = [cardElementArray objectAtIndex:i];
        NSString *imgName = [self getCardBackName];
        [self flipIV:ce.iv withImgName:imgName];
    }
    exchangeCardsButton.userInteractionEnabled = NO;
  //  [self performSelector:@selector(enablePlayerArrangeCards) withObject:nil afterDelay:0.6];
}

-(void) flipIV:(UIImageView*) iv withImgName:(NSString*) imgName {
    
    iv.image = [UIImage imageNamed:imgName];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut]; 
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:iv cache:NO];
    [UIView commitAnimations];
}

-(void) enablePlayerArrangeCards {
    for (int i=0; i<4; i++) {
        CardElement *ce = [cardElementArray objectAtIndex:i];
        ce.iv.userInteractionEnabled = YES;
        
        CardElement *ece = [emptyCardElementArray objectAtIndex:i];
        ece.iv.userInteractionEnabled = YES;
    }
    exchangeCardsButton.userInteractionEnabled = YES;
}

-(int*) getCardNumberArray {
    int *cardNumberArray = malloc(sizeof(int) * 4);
    for (int i=0; i<4; i++) {
        CardElement *ce = [cardElementArray objectAtIndex:i];
        cardNumberArray[i] = ce.number;
    }
    return cardNumberArray;
}

-(void) resetCard {
    for (int i=0; i<4; i++) {
        CardElement *ce = [cardElementArray objectAtIndex:i];
        ce.subIV.hidden = YES;
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             ce.iv.alpha = 0.0;                         } 
                         completion:^(BOOL finished){
                             ce.iv.image = nil;
                             ce.iv.alpha = 1.0;
                         }];

    }
    
/*    int currentTempCardNum = [tempCardElementArray count];
    for (int i=0; i< currentTempCardNum; i++) {
        CardElement *ce = [tempCardElementArray objectAtIndex:i];
        [self releaseTempCardElement:ce];
    }*/
    
    while ([tempCardElementArray count] > 0) {
        CardElement *ce = [tempCardElementArray objectAtIndex:0];
        [self releaseTempCardElement:ce];
    }
}

-(NSMutableArray*) initializeDeckArray {
    int *deckNumberArray = malloc(sizeof(int) * CARD_NUM);
    for (int i=0; i<CARD_NUM; i++) {
        deckNumberArray[i] = i%4 + 1;
    }
    
    //------------------------------
    int n = (time(0) + playerEnum *7 )%100;
    srand(time(0) + playerEnum *7);
    
    for (int count = 0; count < n; count++) {
        for (int i=0; i<(CARD_NUM-1); i++) {
            int r = i + (rand() % (CARD_NUM-i)); // Random remaining position.
            int temp = deckNumberArray[i]; 
            deckNumberArray[i] = deckNumberArray[r]; 
            deckNumberArray[r] = temp;
        }
    }
    
    NSMutableArray *newDeckArray = [[NSMutableArray alloc] init];
    for (int i=0; i< CARD_NUM; i++) {
        int number = deckNumberArray[i];
        [newDeckArray addObject:[NSNumber numberWithInt:number]];
    }
    return newDeckArray;
}

-(void) displayMenu:(int) actionEnum:(int) peepNum {
    
    if (actionEnum == ACTION_NONE) {
        actionLb.text = @"";
    } else if(actionEnum == ACTION_PLACE) {
        actionLb.text = @"Place";
    } else {
        actionLb.text = @"Remove";
    }
    // show peeps
    for (int i=0; i<4; i++) {
        UIImageView *iv = [menuPeepArray objectAtIndex:i];
        iv.image = [UIImage imageNamed:nil];
    }
    
    if (actionEnum != ACTION_NONE) {
        int targetPeepEnum = playerEnum;
        if (actionEnum == ACTION_REMOVE && peepNum > 0) {
            targetPeepEnum = (playerEnum + 1)%2;
        }
        
       // if (peepNum < 0) {
       //     peepNum = -1*peepNum;
       // }
        for (int i=0; i< abs(peepNum); i++) {
            UIImageView *iv = [menuPeepArray objectAtIndex:i];
            
            iv.image = [UIImage imageNamed:[self getDiscFileName:targetPeepEnum]];
        }
    }
    
    
    // create animation IV
    UIImageView *animationIV = [[UIImageView alloc] initWithFrame:CGRectMake(playerEnum *972.0, -640.0, 52, 640)];
    [animationIV setBackgroundColor:[UIColor whiteColor]];
    [baseView addSubview:animationIV]; 
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         animationIV.frame = menuView.frame;
                     } 
                     completion:^(BOOL finished){
                         [animationIV removeFromSuperview];
                         menuView.hidden = NO;
                         
                     }];
}

-(void) closeMenu {
    
    // create animation IV
    UIImageView *animationIV = [[UIImageView alloc] initWithFrame:menuView.frame];
    [animationIV setBackgroundColor:[UIColor whiteColor]];
    [baseView addSubview:animationIV]; 
    
    menuView.hidden = YES;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         animationIV.frame = CGRectMake(playerEnum *972.0, -640.0, 52, 640);
                     } 
                     completion:^(BOOL finished){
                         [animationIV removeFromSuperview];
                         
                     }];
}

-(NSString*) getDiscFileName:(int) targetEnum {
    if (targetEnum == PLAYER_RED) {
        return @"Red_Disc.png";
    } else {
        return @"Blue_Disc.png";
    }
}
@end
