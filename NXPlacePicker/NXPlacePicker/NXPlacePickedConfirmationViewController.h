//
//  PopUpUserPlace.h
//  PlaceServiceMapKit
//
//  Created by Vu Tinh on 3/23/17.
//  Copyright © 2017 Vu Tinh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol NxPlacePickedConfirmationDelegate <NSObject>

-(void) viewController: (nonnull UIViewController*) viewController didConfirmPlace:(nonnull MKPlacemark *)placemark;

@end

@interface NXPlacePickedConfirmationViewController : UIViewController

@property (nonatomic, strong, nonnull) MKPlacemark* mkPlacemark;
@property (nonatomic, weak, nullable) id<NxPlacePickedConfirmationDelegate> delegate;

@end

@interface MKPlacemark (Formatter)

- (nonnull NSString*) formattedAddress;

@end
