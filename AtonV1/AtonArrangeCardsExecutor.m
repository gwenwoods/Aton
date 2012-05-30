//
//  AtonArrangeCardsExecutor.m
//  AtonV1
//
//  Created by Wen Lin on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AtonArrangeCardsExecutor.h"

@implementation AtonArrangeCardsExecutor

enum CARD_CASE_ENUM {
CASE_4444, CASE_3333, CASE_2222, CASE_1111,

CASE_4443, CASE_4442, CASE_4441, CASE_3334, CASE_3332, CASE_3331,
CASE_2224, CASE_2223, CASE_2221, CASE_1114, CASE_1113, CASE_1112,

CASE_4433, CASE_4422, CASE_4411, CASE_3322, CASE_3311, CASE_2211,

CASE_4432, CASE_4431, CASE_4421, CASE_3342, CASE_3341, CASE_3321,
CASE_2243, CASE_2241, CASE_2231, CASE_1143, CASE_1142, CASE_1132,

CASE_1234
};
-(id)initializeWithParameters:(AtonGameParameters*) atonParameter:(AtonGameManager*) atonGameManager:(AtonMessageMaster*) atonMessageMaster:(AtonAI*) atonAI {
	if (self) {
        para = atonParameter;
        gameManager = atonGameManager;
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
            outputCardArray = [self handle_4443];
            break;
            
        case CASE_4442:
            outputCardArray = [self handle_4442];
            break;
            
        case CASE_4441:
            outputCardArray = [self handle_4441];
            break;
        
        case CASE_4433:
            outputCardArray = [self handle_4433];
            break;
        
        case CASE_4422:
            outputCardArray = [self handle_4422];
            break;
        
        case CASE_4411:
            outputCardArray = [self handle_4411];
            break;
            
        case CASE_4432:
            outputCardArray = [self handle_4432];
            break;
            
        case CASE_4431:
            outputCardArray = [self handle_4431];
            break;
            
        case CASE_4421:
            outputCardArray = [self handle_4421];
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
            outputCardArray = [self handle_4321];
            break;
    }
    
    return outputCardArray;
}

-(int*) handle_4443 {
    int* outputCardArray = malloc(sizeof(int)*4);
    if([self nearGameEnd]) {
        outputCardArray[0] = 4;
        outputCardArray[1] = 4;
        outputCardArray[2] = 3;
        outputCardArray[3] = 4;
        return outputCardArray;
    }
    NSMutableArray *templeArray = para.templeArray;
    int t4RedCount_BlueGrey = [[templeArray objectAtIndex:TEMPLE_4] findBlueAndGreyNumForOccupiedEnum:OCCUPIED_RED];
    int t3RedCount_BlueGrey = [[templeArray objectAtIndex:TEMPLE_3] findBlueAndGreyNumForOccupiedEnum:OCCUPIED_RED];

    int* peepDiff = [TempleUtility findPeepDiffEachTemple:templeArray];
    
    if (t4RedCount_BlueGrey >= 2 && peepDiff[TEMPLE_4] <3) {
        outputCardArray[0] = 3;
        outputCardArray[1] = 4;
        outputCardArray[2] = 4;
        outputCardArray[3] = 4;
        
    } else if (t3RedCount_BlueGrey >= 2 && peepDiff[TEMPLE_3] <3) {
        outputCardArray[0] = 4;
        outputCardArray[1] = 4;
        outputCardArray[2] = 3;
        outputCardArray[3] = 4;
    } else {
        outputCardArray[0] = 4;
        outputCardArray[1] = 3;
        outputCardArray[2] = 4;
        outputCardArray[3] = 4;
    }
    return outputCardArray;
}

-(int*) handle_4442 {
    int* outputCardArray = malloc(sizeof(int)*4);
    if([self nearGameEnd]) {
        outputCardArray[0] = 4;
        outputCardArray[1] = 2;
        outputCardArray[2] = 4;
        outputCardArray[3] = 4;
        return outputCardArray;
    }
    NSMutableArray *templeArray = para.templeArray;
    
    int t4RedCount_BlueGrey = [[templeArray objectAtIndex:TEMPLE_4] findBlueAndGreyNumForOccupiedEnum:OCCUPIED_RED];
    int t2RedCount_BlueGrey = [[templeArray objectAtIndex:TEMPLE_2] findBlueAndGreyNumForOccupiedEnum:OCCUPIED_RED];
    
    int* peepDiff = [TempleUtility findPeepDiffEachTemple:templeArray];
    
    if (t4RedCount_BlueGrey >= 2 && peepDiff[TEMPLE_4] <3) {
        outputCardArray[0] = 2;
        outputCardArray[1] = 4;
        outputCardArray[2] = 4;
        outputCardArray[3] = 4;
        
    } else if (t2RedCount_BlueGrey >= 2 && peepDiff[TEMPLE_2] <3) {
        outputCardArray[0] = 4;
        outputCardArray[1] = 4;
        outputCardArray[2] = 2;
        outputCardArray[3] = 4;
    } else {
        outputCardArray[0] = 4;
        outputCardArray[1] = 2;
        outputCardArray[2] = 4;
        outputCardArray[3] = 4;
    }
    return outputCardArray;
}

-(int*) handle_4441 {
    int* outputCardArray = malloc(sizeof(int)*4);
    if([self nearGameEnd]) {
        outputCardArray[0] = 4;
        outputCardArray[1] = 1;
        outputCardArray[2] = 4;
        outputCardArray[3] = 4;
        return outputCardArray;
    }
    NSMutableArray *templeArray = para.templeArray;
    
    int t4RedCount_BlueGrey = [[templeArray objectAtIndex:TEMPLE_4] findBlueAndGreyNumForOccupiedEnum:OCCUPIED_RED];
    int t3RedCount_BlueGrey = [[templeArray objectAtIndex:TEMPLE_3] findBlueAndGreyNumForOccupiedEnum:OCCUPIED_RED];
    int t1RedCount_BlueGrey = [[templeArray objectAtIndex:TEMPLE_1] findBlueAndGreyNumForOccupiedEnum:OCCUPIED_RED];
    
    int* peepDiff = [TempleUtility findPeepDiffEachTemple:templeArray];
    
    if (t4RedCount_BlueGrey >= 2 && peepDiff[TEMPLE_4] <3) {
        outputCardArray[0] = 1;
        outputCardArray[1] = 4;
        outputCardArray[2] = 4;
        outputCardArray[3] = 4;
        
    } else if (t3RedCount_BlueGrey >= 2 && peepDiff[TEMPLE_3] <3) {
        outputCardArray[0] = 1;
        outputCardArray[1] = 4;
        outputCardArray[2] = 4;
        outputCardArray[3] = 4;
    } else if (t1RedCount_BlueGrey >= 3 && peepDiff[TEMPLE_1] <3){
        outputCardArray[0] = 4;
        outputCardArray[1] = 4;
        outputCardArray[2] = 1;
        outputCardArray[3] = 4;
    } else {
        outputCardArray[0] = 4;
        outputCardArray[1] = 1;
        outputCardArray[2] = 4;
        outputCardArray[3] = 4;
    }
    return outputCardArray;
}

-(int*) handle_4433 {
    int* outputCardArray = malloc(sizeof(int)*4);
    if([self nearGameEnd]) {
        outputCardArray[0] = 4;
        outputCardArray[1] = 4;
        outputCardArray[2] = 3;
        outputCardArray[3] = 3;
        return outputCardArray;
    }
    NSMutableArray *templeArray = para.templeArray;
    
    int t4RedCount_BlueGrey = [[templeArray objectAtIndex:TEMPLE_4] findBlueAndGreyNumForOccupiedEnum:OCCUPIED_RED];
    int t3RedCount_BlueGrey = [[templeArray objectAtIndex:TEMPLE_3] findBlueAndGreyNumForOccupiedEnum:OCCUPIED_RED];
    
    int* peepDiff = [TempleUtility findPeepDiffEachTemple:templeArray];
    
    if (t4RedCount_BlueGrey >= 2 && peepDiff[TEMPLE_4] <3) {
        outputCardArray[0] = 3;
        outputCardArray[1] = 4;
        outputCardArray[2] = 4;
        outputCardArray[3] = 3;
        
    } else if (t3RedCount_BlueGrey >= 2 && peepDiff[TEMPLE_3] <3) {
        outputCardArray[0] = 3;
        outputCardArray[1] = 4;
        outputCardArray[2] = 3;
        outputCardArray[3] = 4;
    } else {
        outputCardArray[0] = 4;
        outputCardArray[1] = 3;
        outputCardArray[2] = 4;
        outputCardArray[3] = 4;
    }
    return outputCardArray;
}

-(int*) handle_4422 {
    int* outputCardArray = malloc(sizeof(int)*4);
    if([self nearGameEnd]) {
        outputCardArray[0] = 4;
        outputCardArray[1] = 4;
        outputCardArray[2] = 2;
        outputCardArray[3] = 2;
        return outputCardArray;
    }
    NSMutableArray *templeArray = para.templeArray;
    
    int t4RedCount_BlueGrey = [[templeArray objectAtIndex:TEMPLE_4] findBlueAndGreyNumForOccupiedEnum:OCCUPIED_RED];
    int t2RedCount_BlueGrey = [[templeArray objectAtIndex:TEMPLE_2] findBlueAndGreyNumForOccupiedEnum:OCCUPIED_RED];
    
    int* peepDiff = [TempleUtility findPeepDiffEachTemple:templeArray];
    
    if (t4RedCount_BlueGrey >= 2 && peepDiff[TEMPLE_4] <3) {
        outputCardArray[0] = 2;
        outputCardArray[1] = 4;
        outputCardArray[2] = 4;
        outputCardArray[3] = 2;
        
    } else if (t2RedCount_BlueGrey >= 2 && peepDiff[TEMPLE_3] <2) {
        outputCardArray[0] = 2;
        outputCardArray[1] = 4;
        outputCardArray[2] = 2;
        outputCardArray[3] = 4;
    } else {
        outputCardArray[0] = 2;
        outputCardArray[1] = 2;
        outputCardArray[2] = 4;
        outputCardArray[3] = 4;
    }
    return outputCardArray;
}

-(int*) handle_4411 {
    int* outputCardArray = malloc(sizeof(int)*4);
    if([self nearGameEnd]) {
        outputCardArray[0] = 4;
        outputCardArray[1] = 4;
        outputCardArray[2] = 1;
        outputCardArray[3] = 1;
        return outputCardArray;
    }
    NSMutableArray *templeArray = para.templeArray;
    
    int t4RedCount_BlueGrey = [[templeArray objectAtIndex:TEMPLE_4] findBlueAndGreyNumForOccupiedEnum:OCCUPIED_RED];
    int t1RedCount_BlueGrey = [[templeArray objectAtIndex:TEMPLE_1] findBlueAndGreyNumForOccupiedEnum:OCCUPIED_RED];
    
    int* peepDiff = [TempleUtility findPeepDiffEachTemple:templeArray];
    
    if (t4RedCount_BlueGrey >= 2 && peepDiff[TEMPLE_4] <3) {
        outputCardArray[0] = 1;
        outputCardArray[1] = 4;
        outputCardArray[2] = 4;
        outputCardArray[3] = 1;
        
    } else if (t1RedCount_BlueGrey >= 2 && peepDiff[TEMPLE_1] <2) {
        outputCardArray[0] = 1;
        outputCardArray[1] = 4;
        outputCardArray[2] = 1;
        outputCardArray[3] = 4;
    } else {
        outputCardArray[0] = 1;
        outputCardArray[1] = 1;
        outputCardArray[2] = 4;
        outputCardArray[3] = 4;
    }
    return outputCardArray;
}

-(int*) handle_4432 {
    int* outputCardArray = malloc(sizeof(int)*4);
    if([self nearGameEnd]) {
        outputCardArray[0] = 4;
        outputCardArray[1] = 4;
        outputCardArray[2] = 3;
        outputCardArray[3] = 2;
        return outputCardArray;
    }
    NSMutableArray *templeArray = para.templeArray;
    
    int t4RedCount_BlueGrey = [[templeArray objectAtIndex:TEMPLE_4] findBlueAndGreyNumForOccupiedEnum:OCCUPIED_RED];
    int t3RedCount_BlueGrey = [[templeArray objectAtIndex:TEMPLE_3] findBlueAndGreyNumForOccupiedEnum:OCCUPIED_RED];
    
    int* peepDiff = [TempleUtility findPeepDiffEachTemple:templeArray];
    
    if (t4RedCount_BlueGrey >= 2 && peepDiff[TEMPLE_4] <3) {
        outputCardArray[0] = 2;
        outputCardArray[1] = 4;
        outputCardArray[2] = 4;
        outputCardArray[3] = 3;
        
    } else if (t3RedCount_BlueGrey >= 2 && peepDiff[TEMPLE_3] <3) {
        outputCardArray[0] = 2;
        outputCardArray[1] = 4;
        outputCardArray[2] = 3;
        outputCardArray[3] = 4;
    } else {
        outputCardArray[0] = 4;
        outputCardArray[1] = 2;
        outputCardArray[2] = 3;
        outputCardArray[3] = 4;
    }
    return outputCardArray;
}

-(int*) handle_4431 {
    int* outputCardArray = malloc(sizeof(int)*4);
    if([self nearGameEnd]) {
        outputCardArray[0] = 4;
        outputCardArray[1] = 4;
        outputCardArray[2] = 1;
        outputCardArray[3] = 3;
        return outputCardArray;
    }
    NSMutableArray *templeArray = para.templeArray;
    
    int t4RedCount_BlueGrey = [[templeArray objectAtIndex:TEMPLE_4] findBlueAndGreyNumForOccupiedEnum:OCCUPIED_RED];
    int t3RedCount_BlueGrey = [[templeArray objectAtIndex:TEMPLE_3] findBlueAndGreyNumForOccupiedEnum:OCCUPIED_RED];

    int* peepDiff = [TempleUtility findPeepDiffEachTemple:templeArray];
    
    if (t4RedCount_BlueGrey >= 2 && peepDiff[TEMPLE_4] <3) {
        outputCardArray[0] = 1;
        outputCardArray[1] = 4;
        outputCardArray[2] = 4;
        outputCardArray[3] = 3;
    
    } else if (t3RedCount_BlueGrey >= 2 && peepDiff[TEMPLE_3] <3) {
        outputCardArray[0] = 1;
        outputCardArray[1] = 4;
        outputCardArray[2] = 3;
        outputCardArray[3] = 4;
    } else {
        outputCardArray[0] = 4;
        outputCardArray[1] = 1;
        outputCardArray[2] = 3;
        outputCardArray[3] = 4;
    }
    return outputCardArray;
}

-(int*) handle_4421 {
    int* outputCardArray = malloc(sizeof(int)*4);
    if([self nearGameEnd]) {
        outputCardArray[0] = 4;
        outputCardArray[1] = 4;
        outputCardArray[2] = 1;
        outputCardArray[3] = 2;
        return outputCardArray;
    }
    NSMutableArray *templeArray = para.templeArray;
    
    int t4RedCount_BlueGrey = [[templeArray objectAtIndex:TEMPLE_4] findBlueAndGreyNumForOccupiedEnum:OCCUPIED_RED];
    int t2RedCount_BlueGrey = [[templeArray objectAtIndex:TEMPLE_2] findBlueAndGreyNumForOccupiedEnum:OCCUPIED_RED];
    
    int* peepDiff = [TempleUtility findPeepDiffEachTemple:templeArray];
    
    if (t4RedCount_BlueGrey >= 2 && peepDiff[TEMPLE_4] <3) {
        outputCardArray[0] = 1;
        outputCardArray[1] = 4;
        outputCardArray[2] = 4;
        outputCardArray[3] = 2;
        
    } else if (t2RedCount_BlueGrey >= 2 && peepDiff[TEMPLE_2] <3) {
        outputCardArray[0] = 1;
        outputCardArray[1] = 4;
        outputCardArray[2] = 2;
        outputCardArray[3] = 4;
    } else {
        outputCardArray[0] = 4;
        outputCardArray[1] = 1;
        outputCardArray[2] = 2;
        outputCardArray[3] = 4;
    }
    return outputCardArray;
}

-(int*) handle_3322 {
    int* outputCardArray = malloc(sizeof(int)*4);
    if([self nearGameEnd]) {
        outputCardArray[0] = 3;
        outputCardArray[1] = 3;
        outputCardArray[2] = 2;
        outputCardArray[3] = 2;
        return outputCardArray;
    }
    NSMutableArray *templeArray = para.templeArray;
    
    int t3BlueOccupiedEnum = [[templeArray objectAtIndex:TEMPLE_3] findBlueOccupiedEnum];
    int t2BlueOccupiedEnum = [[templeArray objectAtIndex:TEMPLE_2] findBlueOccupiedEnum];
    int t3RedGreyCount = [[templeArray objectAtIndex:TEMPLE_3] findGreyNumForOccupiedEnum:OCCUPIED_RED];
    int t2RedGreyCount = [[templeArray objectAtIndex:TEMPLE_2] findGreyNumForOccupiedEnum:OCCUPIED_RED];

    int* peepDiff = [TempleUtility findPeepDiffEachTemple:templeArray];

    if (t3BlueOccupiedEnum == OCCUPIED_RED || t3RedGreyCount > 0) {
        outputCardArray[0] = 2;
        outputCardArray[1] = 3;
        outputCardArray[2] = 3;
        outputCardArray[3] = 2;
    } else if (t2BlueOccupiedEnum == OCCUPIED_RED || t2RedGreyCount > 0) {
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

-(int*) handle_4321 {
    int* outputCardArray = malloc(sizeof(int)*4);
    if([self nearGameEnd]) {
        outputCardArray[0] = 4;
        outputCardArray[1] = 3;
        outputCardArray[2] = 1;
        outputCardArray[3] = 2;
        return outputCardArray;
    }
    NSMutableArray *templeArray = para.templeArray;

    int t3BlueOccupiedEnum = [[templeArray objectAtIndex:TEMPLE_3] findBlueOccupiedEnum];
    int t2BlueOccupiedEnum = [[templeArray objectAtIndex:TEMPLE_2] findBlueOccupiedEnum];
    int t3RedGreyCount = [[templeArray objectAtIndex:TEMPLE_3] findGreyNumForOccupiedEnum:OCCUPIED_RED];
    int t2RedGreyCount = [[templeArray objectAtIndex:TEMPLE_2] findGreyNumForOccupiedEnum:OCCUPIED_RED];

    if (t3BlueOccupiedEnum == OCCUPIED_RED || t3RedGreyCount > 0) {
        if (t3RedGreyCount > 1) {
            outputCardArray[0] = 1;
            outputCardArray[1] = 4;
            outputCardArray[2] = 3;
            outputCardArray[3] = 2;
        } else {
            outputCardArray[0] = 1;
            outputCardArray[1] = 3;
            outputCardArray[2] = 4;
            outputCardArray[3] = 2;
        }
        
    } else if (t2BlueOccupiedEnum == OCCUPIED_RED || t2RedGreyCount > 0) {
        outputCardArray[0] = 1;
        outputCardArray[1] = 4;
        outputCardArray[2] = 2;
        outputCardArray[3] = 3;
    } else {
        outputCardArray[0] = 2;
        outputCardArray[1] = 1;
        outputCardArray[2] = 4;
        outputCardArray[3] = 3;
    }
    return outputCardArray;
}

-(BOOL) nearGameEnd {
    NSMutableArray *playerArray = para.playerArray;
    AtonPlayer *redPlayer = [playerArray objectAtIndex:PLAYER_RED];
    AtonPlayer *bluePlayer = [playerArray objectAtIndex:PLAYER_BLUE];
    if(redPlayer.score >= 32 || bluePlayer.score >= 32) {
        return YES;
    }
    return NO;

}
@end
