//
//  AudioUtility.h
//  AtonV1
//
//  Created by Wen Lin on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioUtility : NSObject

+(AVAudioPlayer*) initLoopAudio:(NSString*) filename:(double) volume;

@end
