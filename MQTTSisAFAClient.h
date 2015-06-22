//
//  MQTTSisAFAClient.h
//  SisAFA
//
//  Created by Bryan Fernandes on 22/05/15.
//  Copyright (c) 2015 Bryan Fernandes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MQTTKit.h>

@interface MQTTSisAFAClient : NSObject

// create a property for the MQTTClient that is used to send and receive the message
@property (nonatomic, strong) MQTTClient *client;

- (void)subscribeToATopicAndReceiveMessages;
- (void)sendMessage;
- (void)disconnectFromTheServer;

+ (id)sharedClient;

@end
