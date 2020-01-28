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

@property(nonatomic, weak)id <MultipeerConnectivityDelegate> delegate;
//@property(nonatomic, weak)id <MCBrowserViewControllerDelegate> delegate;

- (void)sendToAllPeers:(NSData *)data;

- (void)findMultiPeerSession;

- (NSArray<MCPeerID *> *)connectedPeers;

@end

NS_ASSUME_NONNULL_END
