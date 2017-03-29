//
//  NXPlacePickerViewController.h
//  PlaceServiceMapKit
//
//  Created by Vu Tinh on 3/22/17.
//  Copyright © 2017 Vu Tinh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@class NXPlacePickerViewController;

@protocol NXPlacePickerDelegate <NSObject>

- (void) placePicker: (nonnull NXPlacePickerViewController *) viewController
      didSelectPlace: (nonnull MKPlacemark *) place;

@end

@interface NXPlacePickerViewController : UIViewController <MKMapViewDelegate>

@property (weak, nullable) id<NXPlacePickerDelegate> delegate;

+ (nonnull instancetype) initWithDelegate: (nullable id<NXPlacePickerDelegate>) delegate;

@end
