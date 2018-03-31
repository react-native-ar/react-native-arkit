//
//  Switcher.h
//  RCTARKit
//
//  Created by Marco Wettstein on 31.03.18.
//  Copyright © 2018 HippoAR. All rights reserved.
//


typedef void (^CaseBlock)();

@interface Switcher : NSObject

+ (void)switchOnString:(NSString *)tString
                 using:(NSDictionary<NSString *, CaseBlock> *)tCases
           withDefault:(CaseBlock)tDefaultBlock;

@end
