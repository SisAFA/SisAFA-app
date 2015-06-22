//
//  MQTTSisAFAClient.m
//  SisAFA
//
//  Created by Bryan Fernandes on 22/05/15.
//  Copyright (c) 2015 Bryan Fernandes. All rights reserved.
//

#import "MQTTSisAFAClient.h"

//#define kMQTTServerHost @"iot.eclipse.org"
//#define kTopic @"/MQTTKit/example"
#define kMQTTServerHost @"matheusfonseca.me"
#define kTopic @"sisafa/sisafa_test/test"

@implementation MQTTSisAFAClient

- (void)subscribeToATopicAndReceiveMessages
{
    // create the client with a unique client ID
    NSString *clientID = [UIDevice currentDevice].identifierForVendor.UUIDString;
    NSLog(clientID);
    self.client = [[MQTTClient alloc] initWithClientId:clientID];
    self.client.username = @"sisafa_test";
    self.client.password = @"T5KIP1";
    self.client.port = 1883;
    
    // connect the MQTT client
    [self.client connectToHost:kMQTTServerHost
             completionHandler:^(MQTTConnectionReturnCode code) {
                 if (code == ConnectionAccepted) {
                     // when the client is connected, subscribe to the topic to receive message.
                     [self.client subscribe:kTopic
                      withCompletionHandler:^(NSArray *grantedQos) {
                          // The client is effectively subscribed to the topic when this completion handler is called
                          NSLog(@"subscribed to topic %@", kTopic);
                      }];
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
                     [self.client publishString:@"MQTT iOS"
                                        toTopic:kTopic
                                        withQos:AtMostOnce
                                         retain:NO
                              completionHandler:^(int mid) {
                                  
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
