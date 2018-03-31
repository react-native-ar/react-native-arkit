//
//  Switcher.m
//  RCTARKit
//
//  Created by Marco Wettstein on 31.03.18.
//  Copyright © 2018 HippoAR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Switcher.h"


@implementation Switcher

+ (void)switchOnString:(NSString *)tString
                 using:(NSDictionary<NSString *, CaseBlock> *)tCases
           withDefault:(CaseBlock)tDefaultBlock
{
    CaseBlock blockToExecute = tCases[tString];
    if (blockToExecute) {
        blockToExecute();
    } else {
        tDefaultBlock();
    }
}

@end
