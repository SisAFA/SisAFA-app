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
@property (nonatomic) int isActivated;          //0 (desligado), 1 (ligado) e 2 (disparado) - status - subscribe
@property (nonatomic) int powerOperation;       //0 (ligar), 1 (desligar) - comando - publisher
@property (nonatomic) NSString *GPSData;        // longitude, latitude, data, hora

- (void)subscribeToATopicAndReceiveMessages;
- (void)sendMessage;
- (void)disconnectFromTheServer;

+ (id)sharedClient;

@end
