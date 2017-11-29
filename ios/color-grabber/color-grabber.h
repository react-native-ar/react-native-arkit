//
//  color-grabber.h
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import <React/RCTBridgeModule.h>

@interface ColorGrabber : NSObject <RCTBridgeModule>

+ (instancetype)sharedInstance;
- (NSArray *)getColorsFromImage:(UIImage *)image options:(NSDictionary *)options;
@end
