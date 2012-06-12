//
//  LiteSlot.h
//  AtonV1
//
//  Created by Wen Lin on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiteSlot : NSObject {
    int templeEnum;
    int slotID;
}

@property(nonatomic) int templeEnum, slotID;
@end
