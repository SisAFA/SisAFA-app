//
//  Information.m
//  SisAFA
//
//  Created by Bryan Fernandes on 06/05/15.
//  Copyright (c) 2015 Projeto Integrador 2. All rights reserved.
//

#import "Information.h"

//alert view
#define CANCEL_BUTTON 0
#define YES_BUTTON 1

#define ACTIVATION_COMMAND @"1"

@interface Information ()

@end

@implementation Information
{
    NSUInteger amountOfAnnotations;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //dispatch_async(dispatch_get_main_queue(), ^{
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(setSisAFAPosition) userInfo:nil repeats:YES];
    
    //});
}

- (void)setSisAFAPosition
{
    NSMutableArray *allAnnotations = [[MQTTSisAFAClient sharedClient] allMapAnnotations];
    for (MKPointAnnotation *annotation in allAnnotations) {
        [self.mapView addAnnotation:annotation];
    }
    
    [self zoomToFitMapAnnotations];
}

- (void)zoomToFitMapAnnotations {
    
    if ([self.mapView.annotations count] == 0) return;
    int i = 0;
    MKMapPoint points[[self.mapView.annotations count]];
    
    //build array of annotation points
    for (id<MKAnnotation> annotation in [self.mapView annotations]){
        points[i++] = MKMapPointForCoordinate(annotation.coordinate);
    }
    
    MKPolygon *poly = [MKPolygon polygonWithPoints:points count:i];
    [self.mapView setRegion:MKCoordinateRegionForMapRect([poly boundingMapRect]) animated:YES];
}

- (IBAction)silence:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Silent Alarm?"
                                                    message:@"all location data will be lost"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Yes", nil];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == YES_BUTTON) {
        [[MQTTSisAFAClient sharedClient] sendSignalToPublisher:ACTIVATION_COMMAND];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
