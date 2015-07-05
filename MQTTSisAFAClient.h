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
#import <MapKit/MapKit.h>


@interface MQTTSisAFAClient : NSObject

// create a property for the MQTTClient that is used to send and receive the message
@property (nonatomic, strong) MQTTClient *client;
@property (nonatomic) int isActivated;          //0 (desligado), 1 (ligado) e 2 (disparado) - status - subscribe
//@property (nonatomic) int powerOperation;       //0 (ligar), 1 (desligar), 2 (disparar) - comando - publisher
@property (nonatomic) NSString *GPSData;        // longitude, latitude, data, hora
@property (nonatomic) MKMapView *map;
//@property (nonatomic) Information *currentViewController;
//@property (nonatomic) HomeScreen *test;

- (void)subscribeToAStatusAndGPSTopcis;
- (void)sendSignalToPublisher:(NSString *)signal;
- (void)sendGPSToTest:(NSString *)message;
- (void)sendStatusToTest:(NSString *)message;
- (void)disconnectFromTheServer;

+ (id)sharedClient;

@end
