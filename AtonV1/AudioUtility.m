//
//  AudioUtility.m
//  AtonV1
//
//  Created by Wen Lin on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AudioUtility.h"

@implementation AudioUtility

+(AVAudioPlayer*) initLoopAudio:(NSString*) fileName:(double) volume {
    
    NSURL *urlOpen = [NSURL fileURLWithPath:[NSString stringWithFormat:fileName, [[NSBundle mainBundle] resourcePath]]];
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:urlOpen error:nil];
	audioPlayer.numberOfLoops = 1000;
    audioPlayer.volume = volume;
    [audioPlayer prepareToPlay];
    
    return audioPlayer;
}

@end
