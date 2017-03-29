//
//  NXPlacePickerViewController.m
//  PlaceServiceMapKit
//
//  Created by Vu Tinh on 3/22/17.
//  Copyright © 2017 Vu Tinh. All rights reserved.
//

#import "NXPlacePickerViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "NXPlaceSearchViewController.h"
#import "NXPlacePickedConfirmationViewController.h"

typedef enum {
    DisplayStateFull = 0,
    DisplayStateLow = 1
} DisplayState;

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface NXPlacePickerViewController () <UIGestureRecognizerDelegate, NxPlacePickedConfirmationDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBottomSheetConstraint;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableViewNearby;
@property (weak, nonatomic) IBOutlet UIView *viewSearch;
@property (weak, nonatomic) IBOutlet UIButton *currentLocationButton;

@property(nonatomic,strong) MKPlacemark *selectedPin;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray<MKPlacemark *> *placemarks;

@property (nonatomic) DisplayState displayState;

@end

@implementation NXPlacePickerViewController

+ (instancetype)initWithDelegate:(id<NXPlacePickerDelegate>)delegate {
    NSBundle* bundle = [NSBundle bundleForClass:NXPlacePickerViewController.self];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: bundle];
    NXPlacePickerViewController* vc = storyboard.instantiateInitialViewController;
    vc.delegate = delegate;
    
    return vc;
}

@synthesize topBottomSheetConstraint = _topBottomSheetConstraint;

CGFloat fullScreenTopConstant = 0;
CGFloat bottomSheetTopConstant = 80;
CGFloat cellHeight = 44;
CGFloat minVelocity = 200;
CGFloat statusBarHeight = 20;
BOOL isPanGestureChanging = false;

CGFloat newTopConstant;

-(NSLayoutConstraint *)topBottomSheetConstraint
{
    return _topBottomSheetConstraint;
}

-(CGFloat) middleTopConstant
{
    return (fullScreenTopConstant + bottomSheetTopConstant) * 0.5 + 60;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.showsUserLocation = true;
    self.mapView.delegate = self;
    
    
    self.viewSearch.layer.cornerRadius = 2;
    self.viewSearch.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.viewSearch.layer.shadowOffset = CGSizeMake(0, 1);
    self.viewSearch.layer.shadowRadius = 3;
    self.viewSearch.layer.shadowOpacity = 1;
    self.viewSearch.layer.masksToBounds = false;
    
    self.currentLocationButton.layer.cornerRadius = 20;
    self.currentLocationButton.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.currentLocationButton.layer.shadowOffset = CGSizeMake(0, 1);
    self.currentLocationButton.layer.shadowRadius = 3;
    self.currentLocationButton.layer.shadowOpacity = 1;
    self.currentLocationButton.layer.masksToBounds = false;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [self.locationManager requestWhenInUseAuthorization];
    }
#endif
    
    [self.locationManager requestWhenInUseAuthorization];
    bottomSheetTopConstant = self.view.frame.size.height + 150;
    self.tableViewNearby.delegate = self;
    self.tableViewNearby.dataSource = self;
    self.tableViewNearby.scrollEnabled = false;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.topBottomSheetConstraint.constant = self.middleTopConstant;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goToViewSearchPlace:(UITapGestureRecognizer *)sender {
    NXPlaceSearchViewController *vc = (NXPlaceSearchViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"NXPlaceSearchViewController"];
    vc.region = self.mapView.region;
    vc.delegate = self;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navi animated:YES completion:nil];
}
- (IBAction)goToPopUpUserPlace:(UITapGestureRecognizer *)sender {
    if (self.placemarks == NULL){ return;}
    NXPlacePickedConfirmationViewController *vc = (NXPlacePickedConfirmationViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"NXPlacePickedConfirmationViewController"];
    vc.mkPlacemark = self.placemarks[0];
    vc.delegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)showCurrentLocation:(UIButton *)sender {
    [self.mapView removeAnnotations:self.mapView.annotations];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = self.selectedPin.coordinate;
    annotation.title = self.selectedPin.name;
    
    NSString *cityAndState = [NSString stringWithFormat:@"%@ %@",[self.selectedPin locality], [self.selectedPin locality]];
    
    annotation.subtitle = cityAndState;
    [self.mapView addAnnotation:annotation];
    
    [self.mapView setRegion:MKCoordinateRegionMake(self.selectedPin.coordinate, MKCoordinateSpanMake(0.05, 0.05))
                   animated:true];
}

-(void)getAddressFromLocation:(CLLocation *)location {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!placemarks) {
             // TOODO handle error
             return;
         }
         
         if(placemarks && placemarks.count > 0)
         {
             
             CLPlacemark *placemark= [placemarks objectAtIndex:0];
             MKPlacemark * mkPlacemark = [[MKPlacemark alloc] initWithPlacemark:placemark];
             NSMutableArray *array = [[NSMutableArray alloc] init];
             [array addObject:mkPlacemark];
             self.placemarks = array;
             self.selectedPin = mkPlacemark;
             [self.tableViewNearby reloadData];
         }
     }];
}

-(void) viewController: (UIViewController*) viewController didConfirmPlace:(MKPlacemark *)placemark {
    __weak NXPlacePickerViewController* wSelf = self;
    [viewController dismissViewControllerAnimated:true completion:^{
        if (wSelf.delegate != nil && [wSelf.delegate respondsToSelector:@selector(placePicker:didSelectPlace:)])
        {
            [wSelf.delegate placePicker:wSelf didSelectPlace: wSelf.selectedPin];
        }
    }];
}

// CLLocationManagerDelegate
-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = locations.lastObject;
    [self getAddressFromLocation:location];
    [self.mapView setRegion:MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.05, 0.05)) animated:true];
}

-(void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways)
    {
        [self.locationManager requestLocation];
        
    } else if (status == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        [self.locationManager requestLocation];
    }
    
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error");
}

//// MKMapViewDelegate
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    return nil;
    
}

// UIPanGesture

- (IBAction)handlePanGestures:(UIPanGestureRecognizer *)sender {
    
    CGPoint translation = [sender translationInView:self.view];
    
    if (fabs([sender velocityInView:self.view].y) > 100)
    {
        [self.view endEditing:true];
    }
    if (self.topBottomSheetConstraint.constant >= self.middleTopConstant && [sender velocityInView:self.view].y > 0)
    {
        return;
    }
    
    
    newTopConstant = self.topBottomSheetConstraint.constant + translation.y;
    if (newTopConstant > fullScreenTopConstant && newTopConstant < bottomSheetTopConstant) {
        self.topBottomSheetConstraint.constant = newTopConstant;
        [sender setTranslation:CGPointZero inView:self.view];
    }
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self setTopConstraint:[sender velocityInView:self.view].y];
    }
    
}

-(void) setTopConstraint: (CGFloat) velocityY
{
    
    if (velocityY > minVelocity)
    {
        [self setTopContant:self.middleTopConstant];
    } else {
        [self setTopContant:fullScreenTopConstant];
        self.tableViewNearby.allowsSelection = true;
    }

}

-(void) setTopContant: (CGFloat) contant
{
    [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationCurveEaseOut|UIViewAnimationOptionAllowUserInteraction animations:^{
        self.topBottomSheetConstraint.constant = contant;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

-(DisplayState) displayState
{
    switch (self.displayState) {
        case DisplayStateLow:
            self.topBottomSheetConstraint.constant = fullScreenTopConstant;
        case DisplayStateFull:
            self.topBottomSheetConstraint.constant = self.middleTopConstant;
        default:
            break;
    }
    return self.displayState;
}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ((self.topBottomSheetConstraint.constant <= fullScreenTopConstant && fabs(self.tableViewNearby.contentOffset.y) < 20) || (self.topBottomSheetConstraint.constant >= self.middleTopConstant))
    {
        self.tableViewNearby.scrollEnabled = false;
    } else {
        self.tableViewNearby.scrollEnabled = true;
    }
    
    return false;
}

// UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.placemarks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    MKPlacemark *item = self.placemarks[indexPath.row];
    
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = [item formattedAddress];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKPlacemark *item = self.placemarks[indexPath.row];
    NXPlacePickedConfirmationViewController *vc = (NXPlacePickedConfirmationViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"NXPlacePickedConfirmationViewController"];
    vc.mkPlacemark = item;
    vc.delegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
}

@end
