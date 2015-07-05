//
//  Information.h
//  SisAFA
//
//  Created by Bryan Fernandes on 06/05/15.
//  Copyright (c) 2015 Projeto Integrador 2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQTTSisAFAClient.h"

@interface Information : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UIAlertViewDelegate>

@property MQTTSisAFAClient *testMQTT;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)silence:(id)sender;
- (void)zoomToFitMapAnnotations;
- (void)setSisAFAPosition;

//+ (id) sharedInformation;

@end
