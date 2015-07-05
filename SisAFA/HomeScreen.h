//
//  ViewController.h
//  SisAFA
//
//  Created by Bryan Fernandes on 06/05/15.
//  Copyright (c) 2015 Projeto Integrador 2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQTTSisAFAClient.h"
#import "Information.h"

@interface HomeScreen: UIViewController

- (IBAction)powerButton:(id)sender;
- (IBAction)shootingCarAlarm:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *subscribeStatusSystem;

@end

