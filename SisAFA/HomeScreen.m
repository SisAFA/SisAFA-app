//
//  ViewController.m
//  SisAFA
//
//  Created by Bryan Fernandes on 06/05/15.
//  Copyright (c) 2015 Projeto Integrador 2. All rights reserved.
//

#import "HomeScreen.h"

@interface HomeScreen ()

@end

@implementation HomeScreen
{
    BOOL active;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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
    } else {
        self.labelStatusSystem.text = @"Status: Desactivate";
        active = YES;
    }
}
@end
