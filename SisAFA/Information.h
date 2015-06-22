//
//  Information.h
//  SisAFA
//
//  Created by Bryan Fernandes on 06/05/15.
//  Copyright (c) 2015 Projeto Integrador 2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQTTSisAFAClient.h"

@interface Information : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property NSArray* images;

@property UICollectionView* imagesCollectionView;
@property BOOL active;
@property BOOL mqttConnected;
@property MQTTSisAFAClient *testMQTT;

@end
