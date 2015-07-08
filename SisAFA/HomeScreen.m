//
//  ViewController.m
//  SisAFA
//
//  Created by Bryan Fernandes on 06/05/15.
//  Copyright (c) 2015 Projeto Integrador 2. All rights reserved.
//

#import "HomeScreen.h"

#define ONE_CHARACTER 1

//receive message
#define DESACTIVATE 0
#define ACTIVATE 1
#define ALERT 2

//commands
#define ALERT_COMMAND @"2"
#define ACTIVATION_COMMAND @"1"
#define SHUTDOWN_COMMAND @"0"
#define STORYBOARD_ID @"info"

//gps data
#define LATITUDE 0
#define LONGITUDE 1
#define DATE 2
#define HOUR 3



//check current view controller
//#define HOMESCREEN_CONTROLLER 0
//#define INFORMATION_CONTROLLER 1

@interface HomeScreen ()

@end

@implementation HomeScreen
{
    int temp;
    MQTTSisAFAClient *testMQTT;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    testMQTT = [MQTTSisAFAClient sharedClient];
    [testMQTT subscribeToAStatusAndGPSTopcis];
    
    UILabel *statusSystem = self.subscribeStatusSystem;
    HomeScreen *homeScreenController = self;
    
    // define the handler that will be called when MQTT messages are received by the client
    [testMQTT.client setMessageHandler:^(MQTTMessage *message) {
        NSString *text = message.payloadString;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"received message %@", text);
            //tratar
            if ([text length] == ONE_CHARACTER) {
                [[MQTTSisAFAClient sharedClient] setIsActivated:[text intValue]];
                
                if ([[MQTTSisAFAClient sharedClient] isActivated] == DESACTIVATE) {
                    
                    statusSystem.text = @"Status: Desactivate";
                    
                } else if([[MQTTSisAFAClient sharedClient] isActivated] == ACTIVATE) {
                    
                    statusSystem.text = @"Status: Activate";
                    
                } else if ([[MQTTSisAFAClient sharedClient] isActivated] == ALERT) {
                    
                    //present information controller
                    Information *informationController = [homeScreenController.storyboard instantiateViewControllerWithIdentifier:STORYBOARD_ID];
                    //[[MQTTSisAFAClient sharedClient] setCurrentViewController:informationController];
                    [homeScreenController presentViewController:informationController animated:YES completion:nil];
                }
                
                NSLog(@"test: %d", [[MQTTSisAFAClient sharedClient] isActivated]);
                
            } else if ([[MQTTSisAFAClient sharedClient] isActivated] == ALERT){
                //set receive GPS data only if activate status
                //[[MQTTSisAFAClient sharedClient] setGPSData:text];
                [homeScreenController buildAnnotation:text];
            }
        });
        
    }];
}

- (void)buildAnnotation:(NSString *)receive
{
    //get gps data
    NSArray *data = [receive componentsSeparatedByString:@","];
    
    // formatting date
    NSMutableString *date = [NSMutableString stringWithString:[data objectAtIndex:DATE]];
    [date insertString:@"/" atIndex:4];
    [date insertString:@"/" atIndex:7];
    [date insertString:@" - " atIndex:10];
    [date insertString:@":" atIndex:15];
    [date insertString:@":" atIndex:18];
    
    //formatting hour
//    NSMutableString *hour = [NSMutableString stringWithString:[data objectAtIndex:HOUR]];
//    [hour insertString:@":" atIndex:2];
//    [hour insertString:@":" atIndex:5];
    
    //join date and hour to set as title annotation
//    [date appendString:@" - "];
//    [date appendString:hour];
//    
    //treat gps coordinates
    //MKCoordinateRegion myRegion;
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D myCoordinate;
    
    myCoordinate.latitude = [[data objectAtIndex:LATITUDE] doubleValue];
    myCoordinate.longitude = [[data objectAtIndex:LONGITUDE] doubleValue];
    annotation.coordinate = myCoordinate;
    annotation.title = date;
    annotation.subtitle = @"SisAFA position";
    
    NSMutableArray *allAnnotations = [[MQTTSisAFAClient sharedClient] allMapAnnotations];
    [allAnnotations addObject:annotation];
    [[MQTTSisAFAClient sharedClient] setAllMapAnnotations:allAnnotations];
    
    NSMutableArray *tmp = [[MQTTSisAFAClient sharedClient] allMapAnnotations];
    for (MKPointAnnotation *pa in tmp) {
        NSLog(@"title: %@, subtitle: %@, latitude: %f, longitude: %f", pa.title, pa.subtitle, pa.coordinate.latitude, pa.coordinate.longitude);
    }
    
}


- (void)viewWillAppear:(BOOL)animated
{
    //[[MQTTSisAFAClient sharedClient] setCurrentViewController:0];
    //[[MQTTSisAFAClient sharedClient] sendGPSToTest:@"-15.987540,-48.544140,030213,022659"];
}

- (IBAction)powerButton:(id)sender
{
    if ([[MQTTSisAFAClient sharedClient] isActivated] == ACTIVATE)
        [[MQTTSisAFAClient sharedClient] sendSignalToPublisher:SHUTDOWN_COMMAND];
    else if ([[MQTTSisAFAClient sharedClient] isActivated] == DESACTIVATE)
        [[MQTTSisAFAClient sharedClient] sendSignalToPublisher:ACTIVATION_COMMAND];
}

- (IBAction)shootingCarAlarm:(id)sender
{
    [[MQTTSisAFAClient sharedClient] sendSignalToPublisher:ALERT_COMMAND];
    //[[MQTTSisAFAClient sharedClient] sendGPSToTest:@"-15.987540,-36.044140,030213,022659"];
//    [[MQTTSisAFAClient sharedClient] sendStatusToTest:@"status"];
}

- (UIViewController *) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;

    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }

    return topController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
