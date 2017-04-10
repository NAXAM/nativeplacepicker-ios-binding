/*
 Copyright 2017 NAXAM
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

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
