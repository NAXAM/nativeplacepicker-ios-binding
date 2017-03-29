//
//  SearchPlaceViewController.m
//  PlaceServiceMapKit
//
//  Created by Vu Tinh on 3/23/17.
//  Copyright © 2017 Vu Tinh. All rights reserved.
//

#import "SearchPlaceViewController.h"
#import <MapKit/MapKit.h>
#import "PopUpUserPlace.h"


@interface SearchPlaceViewController () <UISearchBarDelegate , PopUpUserPlaceDelegate>

@end

@implementation SearchPlaceViewController

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
//            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Map Error",nil)
//                                        message:[error localizedDescription]
//                                       delegate:nil
//                              cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
            return;
        }
        
        if ([response.mapItems count] == 0) {
//            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Results",nil)
//                                        message:nil
//                                       delegate:nil
//                              cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
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
    cell.detailTextLabel.text = item.placemark.addressDictionary[@"Street"];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKPlacemark *item = results.mapItems[indexPath.row].placemark;
    PopUpUserPlace *vc = (PopUpUserPlace *) [self.storyboard instantiateViewControllerWithIdentifier:@"PopUpUserPlace"];
    vc.mkPlacemark = item;
    vc.delegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
}

-(void) didConfirmPlace:(MKPlacemark *)placemark
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didConfirmPlace:)])
    {
        [self.delegate didConfirmPlace:placemark];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
