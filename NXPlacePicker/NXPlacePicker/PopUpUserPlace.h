//
//  PopUpUserPlace.h
//  PlaceServiceMapKit
//
//  Created by Vu Tinh on 3/23/17.
//  Copyright © 2017 Vu Tinh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol PopUpUserPlaceDelegate <NSObject>

-(void) didConfirmPlace:(MKPlacemark *)placemark;

@end

@interface PopUpUserPlace : UIViewController

@property (nonatomic, strong) MKPlacemark* mkPlacemark;
@property (nonatomic, weak) id<PopUpUserPlaceDelegate> delegate;

@end
