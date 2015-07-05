//
//  Information.m
//  SisAFA
//
//  Created by Bryan Fernandes on 06/05/15.
//  Copyright (c) 2015 Projeto Integrador 2. All rights reserved.
//

#import "Information.h"

//gps data
#define LATITUDE 0
#define LONGITUDE 1
#define DATE 2
#define HOUR 3

//alert view
#define CANCEL_BUTTON 0
#define YES_BUTTON 1

#define ACTIVATION_COMMAND @"1"

@interface Information ()

@end

@implementation Information
{
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setSisAFAPosition];
}

- (void)viewWillAppear:(BOOL)animated
{
    //[[MQTTSisAFAClient sharedClient] setCurrentViewController:1];
}

//+ (id) sharedInformation
//{
//    static Information *sharedInformation = nil;
//    
//    return sharedInformation;
//}

- (void)setSisAFAPosition
{
    //get gps data
    NSArray *data = [[[MQTTSisAFAClient sharedClient] GPSData] componentsSeparatedByString:@","];
    
    // formatting date
    NSMutableString *date = [NSMutableString stringWithString:[data objectAtIndex:DATE]];
    [date insertString:@"/" atIndex:2];
    [date insertString:@"/" atIndex:5];
    
    //formatting hour
    NSMutableString *hour = [NSMutableString stringWithString:[data objectAtIndex:HOUR]];
    [hour insertString:@":" atIndex:2];
    [hour insertString:@":" atIndex:5];
    
    //join date and hour to set as title annotation
    [date appendString:@" - "];
    [date appendString:hour];
    
    //treat gps coordinates
    MKCoordinateRegion myRegion;
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D myCoordinate;
    
    myCoordinate.latitude = [[data objectAtIndex:LATITUDE] doubleValue];
    myCoordinate.longitude = [[data objectAtIndex:LONGITUDE] doubleValue];
    annotation.coordinate = myCoordinate;
    annotation.title = date;
    annotation.subtitle = @"SisAFA position";
    
    myRegion.center = myCoordinate;
    [self.mapView setRegion:myRegion animated:YES];
    [self.mapView addAnnotation:annotation];
    
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
