//
//  AtonAIEasy.h
//  AtonV1
//
//  Created by Wen Lin on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonAI.h"
#import "AtonGameParameters.h"
#import "TempleFunctionUtility.h"

@interface AtonAIEasy : AtonAI {
    AtonGameParameters *para;
    NSMutableArray *templeArray;
}

@property(strong, nonatomic) AVAudioPlayer *audioToDeath;

@end
