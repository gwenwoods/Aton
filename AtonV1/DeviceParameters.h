//
//  DeviceParameters.h
//  AtonV1
//
//  Created by Wen Lin on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef AtonV1_DeviceParameters_h
#define AtonV1_DeviceParameters_h

#include <iostream>

struct Frame {
    float upLeft;
    float upRight;
    float downLeft;
    float downRight;
}



class DeviceParameters {
  public:
    hash_map<string, Frame> startMenuMap; 
    
  private:

};

#endif
