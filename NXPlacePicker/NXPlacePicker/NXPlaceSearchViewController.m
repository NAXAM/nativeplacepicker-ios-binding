//
//  SearchPlaceViewController.m
//  PlaceServiceMapKit
//
//  Created by Vu Tinh on 3/23/17.
//  Copyright © 2017 Vu Tinh. All rights reserved.
//

#import "NXPlaceSearchViewController.h"
#import <MapKit/MapKit.h>
#import "NXPlacePickedConfirmationViewController.h"


@interface NXPlaceSearchViewController () <UISearchBarDelegate , NxPlacePickedConfirmationDelegate>

@end

@implementation NXPlaceSearchViewController

MKLocalSearchResponse *results;
@synthesize delegate;
MKCoordinateRegion *_region;


- (void)viewDidLoad {
    [super viewDidLoad];

    UISearchBar *searchBar = [[UISearchBar alloc] init];
    self.navigationItem.titleView = searchBar;
    searchBar.placeholder = @"Search for places";
    searchBar.delegate = self;
    _region = self.region;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// UISearchBarDelegate
-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText == NULL)
    {
        return;
    }
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchText;
    request.region = _region;
    
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (error != nil) {
            //TODO
            return;
        }
        
        results = response;
        
        [self.tableView reloadData];
    }];
}

//#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [results.mapItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    MKMapItem *item = results.mapItems[indexPath.row];
    
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = [item.placemark formattedAddress];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKPlacemark *item = results.mapItems[indexPath.row].placemark;
    NXPlacePickedConfirmationViewController *vc = (NXPlacePickedConfirmationViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"NXPlacePickedConfirmationViewController"];
    vc.mkPlacemark = item;
    vc.delegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
}

-(void) viewController: (UIViewController*) viewController didConfirmPlace:(MKPlacemark *)placemark
{
    __weak NXPlaceSearchViewController *wSelf = self;
    [viewController dismissViewControllerAnimated:true
                                       completion:^{
                                           [wSelf.delegate viewController:wSelf
                                                          didConfirmPlace:placemark];
                                       }];
}

@end
