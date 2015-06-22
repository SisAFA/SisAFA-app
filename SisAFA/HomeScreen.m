//
//  ViewController.m
//  SisAFA
//
//  Created by Bryan Fernandes on 06/05/15.
//  Copyright (c) 2015 Projeto Integrador 2. All rights reserved.
//

#import "HomeScreen.h"
#import "MQTTSisAFAClient.h"

@interface HomeScreen ()

@end

@implementation HomeScreen
{
    BOOL active;
    BOOL mqttConnected;
    MQTTSisAFAClient *testMQTT;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    testMQTT = [[MQTTSisAFAClient alloc] init];
    [testMQTT subscribeToATopicAndReceiveMessages];
    mqttConnected = YES;
    __weak typeof (self) weakSelf = self;
    // define the handler that will be called when MQTT messages are received by the client
    [testMQTT.client setMessageHandler:^(MQTTMessage *message) {
        NSString *text = message.payloadString;
        weakSelf.labelStatusSystem.text = text;
        NSLog(@"received message %@", text);
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)powerButton:(id)sender
{
    if (active) {
        self.labelStatusSystem.text = @"Status: Activate";
        active = NO;
        
        [testMQTT sendMessage];
        mqttConnected = YES;
        
    } else {
        self.labelStatusSystem.text = @"Status: Desactivate";
        active = YES;
        
        if (mqttConnected) {
            //[testMQTT disconnectFromTheServer];
            mqttConnected = NO;
        }
    }
}
@end
