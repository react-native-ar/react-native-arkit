//
//  MultipeerConnectivity.h
//  ARKit
//
//  Created by Mac on 2018/6/5.
//  Copyright © 2018年 AR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^RCTBubblingEventBlock)(NSDictionary *body);
typedef void (^RCTARKitResolve)(id result);
typedef void (^RCTARKitReject)(NSString *code, NSString *message, NSError *error);

@protocol MultipeerConnectivityDelegate <NSObject>
@optional

- (void)receivedDataHandler:(NSData *)data PeerID:(MCPeerID *)peerID;

@end

@interface MultipeerConnectivity : NSObject

@property(nonatomic, strong)MCPeerID *myPeerID;

@property(nonatomic, strong)MCSession *session;

@property(nonatomic, strong)MCNearbyServiceAdvertiser *serviceAdvertiser;

@property(nonatomic, strong)MCNearbyServiceBrowser *serviceBrowser;
@property(nonatomic, strong)MCBrowserViewController *mpBrowser;

@property(nonatomic, strong)NSMutableDictionary *connectedPeersDictionary;

@property(nonatomic, weak)id <MultipeerConnectivityDelegate> delegate;

- (void)sendToAllPeers:(NSData *)data;

- (void)startBrowsingForPeers:(NSString *)serviceType;
- (void)advertiseReadyToJoinSession:(NSString *)serviceType;
- (void)openMultipeerBrowser:(NSString *)serviceType;

//@property (nonatomic, copy) RCTBubblingEventBlock onPeerConnected;
//@property (nonatomic, copy) RCTBubblingEventBlock onPeerConnecting;
//@property (nonatomic, copy) RCTBubblingEventBlock onPeerDisconnected;

- (NSArray<MCPeerID *> *)connectedPeers;

@end

NS_ASSUME_NONNULL_END
