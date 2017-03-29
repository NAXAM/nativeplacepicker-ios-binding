//
//  PopUpUserPlace.m
//  PlaceServiceMapKit
//
//  Created by Vu Tinh on 3/23/17.
//  Copyright © 2017 Vu Tinh. All rights reserved.
//

#import "NXPlacePickedConfirmationViewController.h"



@interface NXPlacePickedConfirmationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLocationLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;



@end

@implementation NXPlacePickedConfirmationViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameLocationLabel.text = self.mkPlacemark.name;
    self.addressLocationLabel.text = self.mkPlacemark.addressDictionary[@"Street"];
    [self setUpMapView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setUpMapView
{
    self.mapView.zoomEnabled = false;
    self.mapView.scrollEnabled = false;
    self.mapView.userInteractionEnabled = false;
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = [self.mkPlacemark coordinate];
    annotation.title = self.mkPlacemark.name;
    
    NSString *cityAndState = [NSString stringWithFormat:@"%@ %@",[self.mkPlacemark locality], [self.mkPlacemark locality]];
    
    annotation.subtitle = cityAndState;
    [self.mapView addAnnotation:annotation];
    
    [self.mapView setRegion:MKCoordinateRegionMake(self.mkPlacemark.coordinate, MKCoordinateSpanMake(0.005, 0.005)) animated:true];
}

- (IBAction)goBack:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionSelect:(UIButton *)sender {
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didConfirmPlace:)])
    {
        [self.delegate didConfirmPlace:self.mkPlacemark];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

@end
