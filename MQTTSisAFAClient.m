//
//  MQTTSisAFAClient.m
//  SisAFA
//
//  Created by Bryan Fernandes on 22/05/15.
//  Copyright (c) 2015 Bryan Fernandes. All rights reserved.
//

#import "MQTTSisAFAClient.h"

#define gpsDataTest @"-15.987540,-48.044140,291091,040159"

#define kMQTTServerHost @"matheusfonseca.me"
#define test_kTopic @"sisafa_test/test"
#define GPS_kTopic @"sisafa_test/gps"
#define status_kTopic @"sisafa_test/status"
#define command_kTopic @"sisafa_test/power"

@implementation MQTTSisAFAClient

- (void)subscribeToAStatusAndGPSTopcis
{
    // connect the MQTT client
    [self.client connectToHost:kMQTTServerHost
             completionHandler:^(MQTTConnectionReturnCode code) {
                 if (code == ConnectionAccepted) {
                     // when the client is connected, subscribe to the topic to receive message
                     
                     [self.client subscribe:GPS_kTopic
                      withCompletionHandler:^(NSArray *grantedQos) {
                          // The client is effectively subscribed to the topic when this completion handler is called
                          NSLog(@"subscribed to topic %@", GPS_kTopic);
                      }];
                     
                     [self.client subscribe:status_kTopic
                      withCompletionHandler:^(NSArray *grantedQos) {
                          // The client is effectively subscribed to the topic when this completion handler is called
                          NSLog(@"subscribed to topic %@", status_kTopic);
                      }];
                 }
             }];
}

- (void)sendSignalToPublisher:(NSString *)signal
{
    [self.client publishString:signal
                       toTopic:status_kTopic
                       withQos:AtMostOnce
                        retain:NO
             completionHandler:^(int mid) {
                 
    }];
}

- (void)sendGPSToTest:(NSString *)message
{
    [self.client publishString:message
                       toTopic:GPS_kTopic
                       withQos:AtMostOnce
                        retain:NO
             completionHandler:^(int mid) {
                 
             }];
}

- (void)sendStatusToTest:(NSString *)message
{
    [self.client publishString:message
                       toTopic:status_kTopic
                       withQos:AtMostOnce
                        retain:NO
             completionHandler:^(int mid) {
                 
             }];
}

- (void)disconnectFromTheServer
{
    [self.client disconnectWithCompletionHandler:^(NSUInteger code) {
        // The client is disconnected when this completion handler is called
        NSLog(@"MQTT client is disconnected");
    }];
}

# pragma mark - SINGLETON

- (id)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use + [SSSingletonData sharedState]" userInfo:nil];
    
    return nil;
}

+ (id) sharedClient
{
    static MQTTSisAFAClient *sharedClient = nil;
    
    if (!sharedClient) {
        sharedClient = [[self alloc] initPrivate];
    }
    
    return sharedClient;
}

- (id) initPrivate
{
    self = [super init];
    
    if (self) {
        NSString *clientID = [UIDevice currentDevice].identifierForVendor.UUIDString;
        _client = [[MQTTClient alloc] initWithClientId:clientID];
        _client.username = @"sisafa_test";
        _client.password = @"T5KIP1";
        _client.port = 1883;
        
        _GPSData = gpsDataTest;
        _map = [[MKMapView alloc] init];
    }
    
    return self;
}

//- (void)setGPSData:(NSString *)GPSData
//{
//    _GPSData = GPSData;
//    _currentViewController = [self topMostController];
//    
//}
//
//- (UIViewController *) topMostController
//{
//    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
//    
//    while (topController.presentedViewController) {
//        topController = topController.presentedViewController;
//    }
//    
//    return topController;
//}

@end
