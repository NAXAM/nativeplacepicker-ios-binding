/*
 Copyright 2017 NAXAM
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

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
    self.addressLocationLabel.text = [self.mkPlacemark formattedAddress];
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
    
    [self.mapView setRegion:MKCoordinateRegionMake(self.mkPlacemark.coordinate, MKCoordinateSpanMake(0.005, 0.005))
                   animated:true];
}

- (IBAction)goBack:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionSelect:(UIButton *)sender {
    [self.delegate viewController:self
                  didConfirmPlace:self.mkPlacemark];
}

@end

@implementation MKPlacemark (Formatter)

- (NSString *)formattedAddress {
    NSArray *lines = self.addressDictionary[@"FormattedAddressLines"];
    return [lines componentsJoinedByString:@", "];
}

@end
