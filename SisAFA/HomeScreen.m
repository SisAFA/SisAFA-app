//
//  ViewController.m
//  SisAFA
//
//  Created by Bryan Fernandes on 06/05/15.
//  Copyright (c) 2015 Projeto Integrador 2. All rights reserved.
//

#import "HomeScreen.h"

#define ONE_CHARACTER 1

//receive message and commands
#define DESACTIVATE 0
#define ACTIVATE 1
#define ALERT 2
#define ALERT_COMMAND @"2"
#define ACTIVATION_COMMAND @"1"
#define SHUTDOWN_COMMAND @"0"
#define STORYBOARD_ID @"info"

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
                    
                    //if not activate, activate before presente information
//                    if ([[MQTTSisAFAClient sharedClient] isActivated] != ACTIVATE) {
//                        [[MQTTSisAFAClient sharedClient] sendSignalToPublisher:ACTIVATION_COMMAND];
//                    }
                    
                    [homeScreenController presentInformationController:homeScreenController];
                }
                
                NSLog(@"test: %d", [[MQTTSisAFAClient sharedClient] isActivated]);
                
            } else if ([[MQTTSisAFAClient sharedClient] isActivated] == ACTIVATE){
                //set receive GPS data only if activate status
                [[MQTTSisAFAClient sharedClient] setGPSData:text];
                
                //if ([[Information sharedInformation] isKindOfClass:[Information class]]) {
                    
                    //[[Information sharedInformation] setSisAFAPosition];
                
                //} else if ([homeScreenController topMostController] == homeScreenController) {
                    
                  //  [homeScreenController presentInformationController:homeScreenController];
                
                //}
                
                NSLog(@"gps: %@", [[MQTTSisAFAClient sharedClient] GPSData]);
            }
        });
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    //[[MQTTSisAFAClient sharedClient] setCurrentViewController:0];
    //[[MQTTSisAFAClient sharedClient] sendGPSToTest:@"-15.987540,-48.544140,030213,022659"];
}

- (void)presentInformationController:(UIViewController *)controller
{
    //present information controller
    Information *informationController = [controller.storyboard instantiateViewControllerWithIdentifier:STORYBOARD_ID];
    //[[MQTTSisAFAClient sharedClient] setCurrentViewController:informationController];
    [controller presentViewController:informationController animated:YES completion:nil];
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
