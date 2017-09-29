//
//  RCTARKitIO.m
//  RCTARKit
//
//  Created by Zehao Li on 9/9/17.
//  Copyright © 2017 HippoAR. All rights reserved.
//

#import "RCTARKitIO.h"
#import <ModelIO/ModelIO.h>
#import <ModelIO/MDLAsset.h>
#import <SceneKit/ModelIO.h>

@implementation RCTARKitIO

+ (instancetype)sharedInstance {
    static RCTARKitIO *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

- (instancetype)init {
    if ((self = [super init])) {
    }
    return self;
}


- (SCNNode *)loadModel:(NSString *)path nodeName:(NSString *)nodeName withAnimation:(BOOL)withAnimation {
    NSURL *url = [self urlFromPath:path];
    NSError* error;
    
    SCNScene *scene = [SCNScene sceneWithURL:url options:nil error:&error];
    if(error) {
        NSLog(@"%@",[error localizedDescription]);
    }
    
    SCNNode *node;
    if (nodeName) {
        node = [scene.rootNode childNodeWithName:nodeName recursively:YES];
    } else {
        node = [[SCNNode alloc] init];
        NSArray *nodeArray = [scene.rootNode childNodes];
        for (SCNNode *eachChild in nodeArray) {
            [node addChildNode:eachChild];
        }
    }
    
    if (withAnimation) {
        NSMutableArray *animationMutableArray = [NSMutableArray array];
        SCNSceneSource *sceneSource = [SCNSceneSource sceneSourceWithURL:url options:@{SCNSceneSourceAnimationImportPolicyKey:SCNSceneSourceAnimationImportPolicyPlayRepeatedly}];
        
        NSArray *animationIds = [sceneSource identifiersOfEntriesWithClass:[CAAnimation class]];
        for (NSString *eachId in animationIds){
            CAAnimation *animation = [sceneSource entryWithIdentifier:eachId withClass:[CAAnimation class]];
            [animationMutableArray addObject:animation];
            
        }
        NSArray *animationArray = [NSArray arrayWithArray:animationMutableArray];
        
        int i = 1;
        for (CAAnimation *animation in animationArray) {
            NSString *key = [NSString stringWithFormat:@"ANIM_%d", i];
            [node addAnimation:animation forKey:key];
            i++;
        }
    }
    
    return node;
}



- (SCNNode *)loadMDLModel:(NSString *)path nodeName:(NSString *)nodeName withAnimation:(BOOL)withAnimation {
    NSURL *url = [self urlFromPath:path];
    MDLAsset *asset = [[MDLAsset alloc] initWithURL:url];
    SCNScene *scene = [SCNScene sceneWithMDLAsset:asset];
    
    SCNNode *node;
    if (nodeName) {
        node = [scene.rootNode childNodeWithName:nodeName recursively:YES];
    } else {
        node = [[SCNNode alloc] init];
        NSArray *nodeArray = [scene.rootNode childNodes];
        for (SCNNode *eachChild in nodeArray) {
            [node addChildNode:eachChild];
        }
    }
    
    if (withAnimation) {
        NSMutableArray *animationMutableArray = [NSMutableArray array];
        SCNSceneSource *sceneSource = [SCNSceneSource sceneSourceWithURL:url options:@{SCNSceneSourceAnimationImportPolicyKey:SCNSceneSourceAnimationImportPolicyPlayRepeatedly}];
        
        NSArray *animationIds = [sceneSource identifiersOfEntriesWithClass:[CAAnimation class]];
        for (NSString *eachId in animationIds){
            CAAnimation *animation = [sceneSource entryWithIdentifier:eachId withClass:[CAAnimation class]];
            [animationMutableArray addObject:animation];
            
        }
        NSArray *animationArray = [NSArray arrayWithArray:animationMutableArray];
        
        int i = 1;
        for (CAAnimation *animation in animationArray) {
            NSString *key = [NSString stringWithFormat:@"ANIM_%d", i];
            [node addAnimation:animation forKey:key];
            i++;
        }
    }
    
    return node;
}


- (NSURL *)urlFromPath:(NSString *)path {
    
    NSURL *url;
    
    if([path hasPrefix: @"/"]) {
        url = [NSURL fileURLWithPath: path];
    } else if ([path rangeOfString:@"scnassets"].location == NSNotFound) {
        NSString *assetPath = [self getAppLibraryCachesPathWithSubDirectory:nil];
        NSString *modelPath = [NSString stringWithFormat:@"file://%@", [assetPath stringByAppendingPathComponent:path]];
        url = [NSURL URLWithString:[modelPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    } else {
        url = [[NSBundle mainBundle] URLForResource:path withExtension:nil];
    }
    
    return url;
}


- (void)saveScene:(SCNScene *)scene as:(NSString *)filename finishHandler:(nullable ARKitIOExportHandler)finishHandler {
    NSString *assetPath = [self getAppLibraryCachesPathWithSubDirectory:nil];
    NSString *exportPath = [NSString stringWithFormat:@"file://%@/%@", assetPath, filename];
    NSLog(@"exportModel to ===> %@", exportPath);
    NSURL *url = [NSURL URLWithString:[exportPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [scene writeToURL:url options:nil delegate:nil progressHandler:^(float totalProgress, NSError * _Nullable error, BOOL * _Nonnull stop) {
        if (totalProgress == 1.0 && finishHandler) {
            finishHandler(filename, exportPath);
        }
    }];
}


- (NSString *)getAppLibraryCachesPathWithSubDirectory:(NSString *)directory {
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
                      stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]];
    if (directory) {
        path = [path stringByAppendingPathComponent:directory];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return path;
}

@end
