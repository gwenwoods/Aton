//
//  AtonArrangeCardsEngine.m
//  AtonV1
//
//  Created by Wen Lin on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonArrangeCardsEngine.h"

@implementation AtonArrangeCardsEngine

enum CARD_CASE_ENUM {
CASE_4444, CASE_3333, CASE_2222, CASE_1111,

CASE_4443, CASE_4442, CASE_4441, CASE_3334, CASE_3332, CASE_3331,
CASE_2224, CASE_2223, CASE_2221, CASE_1114, CASE_1113, CASE_1112,

CASE_4433, CASE_4422, CASE_4411, CASE_3322, CASE_3311, CASE_2211,

CASE_4432, CASE_4431, CASE_4421, CASE_3342, CASE_3341, CASE_3321,
CASE_2243, CASE_2241, CASE_2231, CASE_1143, CASE_1142, CASE_1132,

CASE_1234
};
-(id)initializeWithParameters:(AtonGameParameters*) atonParameter:(AtonMessageMaster*) atonMessageMaster:(AtonAI*) atonAI {
	if (self) {
        para = atonParameter;
        messageMaster = atonMessageMaster;
        useAI = para.useAI;
        ai = atonAI;
    }
    return self;
}

-(int*) arrangeCard:(int*) inputCardArray {
    
    int caseEnum = [self identifyCaseEnum:inputCardArray];
    int* outputCardArray = [self handleCase:caseEnum];

    return outputCardArray;
}

-(int) identifyCaseEnum:(int*) inputCardArray {
    int count1 = 0;
    int count2 = 0;
    int count3 = 0;
    int count4 = 0;
    
    for (int i=0; i<4; i++) {
        
        if (inputCardArray[i] == 1) {
            count1++;
            
        } else  if (inputCardArray[i] == 2) {
            count2++;
            
        } else  if (inputCardArray[i] == 3) {
            count3++;
            
        } else  if (inputCardArray[i] == 4) {
            count4++;
            
        }
    }
    
    if (count4 == 4) {
        return CASE_4444;
        
    } else if (count4 == 3) {
        if (count3 == 1) {
            return CASE_4443;
            
        } else if (count2 == 1) {
            return CASE_4442;
            
        } else if (count1 == 1) {
            return CASE_4441;
            
        }
    } else if (count4 == 2) {
        if (count3 == 2) {
            return CASE_4433;
            
        } else if (count2 == 2) {
            return CASE_4422;
            
        } else if (count1 == 2) {
            return CASE_4411;
            
        } else if (count3 == 1) {
            if (count2 == 1) {
                return CASE_4432;
            } else if(count1 == 1) {
                return CASE_4431;
            }
        } else if (count2 ==1) {
            if (count1==1) {
                return CASE_4421;
            }
        }
    }

    
    if (count3 == 4) {
        return CASE_3333;
    } else if (count3 == 3) {
        if(count4 == 1) {
            return CASE_3334;
        
        } else if(count2 == 1) {
            return CASE_3332;
        
        } else if(count1 == 1) {
            return CASE_3331;
        }
        
    } else if (count3 == 2) {
        if(count2 == 2) {
            return CASE_3322;
        } else if (count1 ==2) {
            return CASE_3311;
        } else if (count4 == 1) {
            if(count2==1) {
                return CASE_3342;
            } else if(count1 == 1) {
                return CASE_3341;
            }
        } else if (count2 == 1) {
            if(count1 == 1) {
                return CASE_3321;
            }
        }
    }
    
    if (count2 == 4) {
        return CASE_2222;
        
    } else if (count2 == 3) {
        if(count4 == 1) {
            return CASE_2224;
            
        } else if(count3 == 1) {
            return CASE_2223;
            
        } else if(count1 == 1) {
            return CASE_2221;
            
        } else {
            return CASE_1234;
        }
    } else if (count2 == 2) {
        if(count1 == 2) {
            return CASE_2211;
            
        } else if (count4 == 1) {
            if(count3==1) {
                return CASE_2243;
            } else if (count1 == 1) {
                return CASE_2241;
            }
            
        } else if(count3 == 1) {
            return CASE_2231;
        }        
    } 
    
    if(count1 == 4) {
        return CASE_4444;
        
    } else if (count1 == 3) {
        if(count4 == 1) {
            return CASE_1114;
        } else if (count3 == 1) {
            return CASE_1113;
        } else if (count2 == 1) {
            return CASE_1112;
        }
    } else if (count1 ==2 ) {
        if(count4 ==1) {
            if(count3==1) {
                return CASE_1143;
            } else if(count2==1) {
                return CASE_1142;
            }
        } else if (count3 == 1) {
            return CASE_1132;
        }
    }

    return CASE_1234;
}

-(int*) handleCase:(int) caseEnum {
    int* outputCardArray = malloc(sizeof(int)*4);
    switch (caseEnum) {
        case CASE_4444:
            outputCardArray[0] = 4;
            outputCardArray[1] = 4;
            outputCardArray[2] = 4;
            outputCardArray[3] = 4;
            break;
        
        case CASE_4443:
            outputCardArray[0] = 4;
            outputCardArray[1] = 3;
            outputCardArray[2] = 4;
            outputCardArray[3] = 4;
            break;
            
        case CASE_4442:
            outputCardArray[0] = 2;
            outputCardArray[1] = 4;
            outputCardArray[2] = 4;
            outputCardArray[3] = 4;
            break;
            
        case CASE_4441:
            outputCardArray[0] = 1;
            outputCardArray[1] = 4;
            outputCardArray[2] = 4;
            outputCardArray[3] = 4;
            break;
        
        case CASE_4433:
            outputCardArray[0] = 3;
            outputCardArray[1] = 4;
            outputCardArray[2] = 3;
            outputCardArray[3] = 4;
            break;
        
        case CASE_4422:
            outputCardArray[0] = 2;
            outputCardArray[1] = 2;
            outputCardArray[2] = 4;
            outputCardArray[3] = 4;
            break;
        
        case CASE_4411:
            outputCardArray[0] = 4;
            outputCardArray[1] = 1;
            outputCardArray[2] = 1;
            outputCardArray[3] = 4;
            break;
            
        case CASE_4432:
            outputCardArray[0] = 4;
            outputCardArray[1] = 2;
            outputCardArray[2] = 3;
            outputCardArray[3] = 4;
            break;
            
        case CASE_4431:
            outputCardArray[0] = 4;
            outputCardArray[1] = 1;
            outputCardArray[2] = 3;
            outputCardArray[3] = 4;
            break;
            
        case CASE_4421:
            outputCardArray[0] = 2;
            outputCardArray[1] = 1;
            outputCardArray[2] = 4;
            outputCardArray[3] = 4;
            break;
        
        case CASE_3333:
            outputCardArray[0] = 3;
            outputCardArray[1] = 3;
            outputCardArray[2] = 3;
            outputCardArray[3] = 3;
            break;
        
        case CASE_3334:
            outputCardArray[0] = 3;
            outputCardArray[1] = 3;
            outputCardArray[2] = 4;
            outputCardArray[3] = 3;
            break;
        
        case CASE_3332:
            outputCardArray[0] = 2;
            outputCardArray[1] = 3;
            outputCardArray[2] = 3;
            outputCardArray[3] = 3;
            break;
        
        case CASE_3331:
            outputCardArray[0] = 1;
            outputCardArray[1] = 3;
            outputCardArray[2] = 3;
            outputCardArray[3] = 3;
            break;
            
        case CASE_3322:
            outputCardArray = [self handle_3322];
            outputCardArray[0] = 2;
            outputCardArray[1] = 3;
            outputCardArray[2] = 2;
            outputCardArray[3] = 3;
            break;
            
        case CASE_3311:
            outputCardArray[0] = 1;
            outputCardArray[1] = 3;
            outputCardArray[2] = 1;
            outputCardArray[3] = 3;
            break;
            
        case CASE_3342:
            outputCardArray[0] = 2;
            outputCardArray[1] = 3;
            outputCardArray[2] = 4;
            outputCardArray[3] = 3;
            break;
            
        case CASE_3341:
            outputCardArray[0] = 1;
            outputCardArray[1] = 3;
            outputCardArray[2] = 4;
            outputCardArray[3] = 3;
            break;
            

            
        case CASE_3321:
            outputCardArray[0] = 1;
            outputCardArray[1] = 3;
            outputCardArray[2] = 2;
            outputCardArray[3] = 3;
            break;
            
        case CASE_2222:
            outputCardArray[0] = 2;
            outputCardArray[1] = 2;
            outputCardArray[2] = 2;
            outputCardArray[3] = 2;
            break;
            
        case CASE_2224:
            outputCardArray[0] = 2;
            outputCardArray[1] = 2;
            outputCardArray[2] = 4;
            outputCardArray[3] = 2;
            break;
        
        case CASE_2223:
            outputCardArray[0] = 2;
            outputCardArray[1] = 2;
            outputCardArray[2] = 3;
            outputCardArray[3] = 2;
            break;
            
        case CASE_2221:
            outputCardArray[0] = 1;
            outputCardArray[1] = 2;
            outputCardArray[2] = 2;
            outputCardArray[3] = 2;
            break;
            
        case CASE_2243:
            outputCardArray[0] = 2;
            outputCardArray[1] = 2;
            outputCardArray[2] = 4;
            outputCardArray[3] = 3;
            break;
            
        case CASE_2241:
            outputCardArray[0] = 2;
            outputCardArray[1] = 1;
            outputCardArray[2] = 4;
            outputCardArray[3] = 2;
            break;
            
        case CASE_2231:
            outputCardArray[0] = 2;
            outputCardArray[1] = 1;
            outputCardArray[2] = 3;
            outputCardArray[3] = 1;
            break;
            
        case CASE_1111:
            outputCardArray[0] = 1;
            outputCardArray[1] = 1;
            outputCardArray[2] = 1;
            outputCardArray[3] = 1;
            break;
            
        case CASE_1114:
            outputCardArray[0] = 4;
            outputCardArray[1] = 1;
            outputCardArray[2] = 1;
            outputCardArray[3] = 1;
            break;
            
        case CASE_1113:
            outputCardArray[0] = 3;
            outputCardArray[1] = 1;
            outputCardArray[2] = 1;
            outputCardArray[3] = 1;
            break;
            
        case CASE_1112:
            outputCardArray[0] = 2;
            outputCardArray[1] = 1;
            outputCardArray[2] = 1;
            outputCardArray[3] = 1;
            break;
        
        case CASE_1143:
            outputCardArray[0] = 1;
            outputCardArray[1] = 1;
            outputCardArray[2] = 4;
            outputCardArray[3] = 3;
            break;
            
        case CASE_1142:
            outputCardArray[0] = 1;
            outputCardArray[1] = 1;
            outputCardArray[2] = 2;
            outputCardArray[3] = 4;
            break;
            
        case CASE_1132:
            outputCardArray[0] = 1;
            outputCardArray[1] = 1;
            outputCardArray[2] = 3;
            outputCardArray[3] = 2;
            break;
            
        default:
            outputCardArray[0] = 2;
            outputCardArray[1] = 1;
            outputCardArray[2] = 4;
            outputCardArray[3] = 3;
            break;
    }
    
    return outputCardArray;
}


-(int*) handle_3322 {
    int* outputCardArray = malloc(sizeof(int)*4);
    NSMutableArray *templeArray = para.templeArray;int t3BlueOccupiedEnum = [[templeArray objectAtIndex:TEMPLE_3] findBlueOccupiedEnum];
    int t2BlueOccupiedEnum = [[templeArray objectAtIndex:TEMPLE_2] findBlueOccupiedEnum];
    int* peepDiff = [TempleUtility findPeepDiffEachTemple:templeArray];

    if (t3BlueOccupiedEnum == OCCUPIED_RED) {
        outputCardArray[0] = 2;
        outputCardArray[1] = 3;
        outputCardArray[2] = 3;
        outputCardArray[3] = 2;
    } else if (t2BlueOccupiedEnum == OCCUPIED_RED) {
        outputCardArray[1] = 3;
        outputCardArray[2] = 2;
        if(peepDiff[1] > 3) {
            outputCardArray[0] = 3;
            outputCardArray[3] = 2;
        } else {
            outputCardArray[0] = 2;
            outputCardArray[3] = 3;
        }
    } else {
        outputCardArray[0] = 2;
        outputCardArray[1] = 2;
        outputCardArray[2] = 3;
        outputCardArray[3] = 3;
    }
    return outputCardArray;
}

@end
