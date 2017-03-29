//
//  SearchPlaceViewController.h
//  PlaceServiceMapKit
//
//  Created by Vu Tinh on 3/23/17.
//  Copyright © 2017 Vu Tinh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "NXPlacePickedConfirmationViewController.h"

@interface NXPlaceSearchViewController : UITableViewController

@property (nonatomic) MKCoordinateRegion region;
@property (nonatomic, weak) id<NxPlacePickedConfirmationDelegate> delegate;

@end
