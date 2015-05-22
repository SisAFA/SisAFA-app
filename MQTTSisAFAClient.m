//
//  MQTTSisAFAClient.m
//  SisAFA
//
//  Created by Bryan Fernandes on 22/05/15.
//  Copyright (c) 2015 Bryan Fernandes. All rights reserved.
//

#import "MQTTSisAFAClient.h"

#define kMQTTServerHost @"iot.eclipse.org"
#define kTopic @"/MQTTKit/example"

@implementation MQTTSisAFAClient

- (void)subscribeToATopicAndReceiveMessages
{
    // create the client with a unique client ID
    NSString *clientID = [UIDevice currentDevice].identifierForVendor.UUIDString;;
    self.client = [[MQTTClient alloc] initWithClientId:clientID];
    
    // define the handler that will be called when MQTT messages are received by the client
    [self.client setMessageHandler:^(MQTTMessage *message) {
        NSString *text = message.payloadString;
        NSLog(@"received message %@", text);
    }];
    
    // connect the MQTT client
    [self.client connectToHost:kMQTTServerHost
             completionHandler:^(MQTTConnectionReturnCode code) {
                 if (code == ConnectionAccepted) {
                     // when the client is connected, subscribe to the topic to receive message.
                     [self.client subscribe:kTopic
                      withCompletionHandler:nil];
                 }
             }];
}

- (void)sendMessage
{
    // connect to the MQTT server
    [self.client connectToHost:kMQTTServerHost
             completionHandler:^(NSUInteger code) {
                 if (code == ConnectionAccepted) {
                     // when the client is connected, send a MQTT message
                     [self.client publishString:@"Hello, MQTT"
                                        toTopic:kTopic
                                        withQos:AtMostOnce
                                         retain:NO
                              completionHandler:^(int mid) {
                                  NSLog(@"message has been delivered");
                              }];
                 }
             }];
}

- (void)disconnectFromTheServer
{
    [self.client disconnectWithCompletionHandler:^(NSUInteger code) {
        // The client is disconnected when this completion handler is called
        NSLog(@"MQTT client is disconnected");
    }];
}

@end
