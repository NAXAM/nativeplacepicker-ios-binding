//
//  LocationSearchTable.swift
//  DemoPlaceServiceSwift
//
//  Created by Vu Tinh on 3/21/17.
//  Copyright © 2017 Vu Tinh. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTable: UITableViewController , UISearchBarDelegate, UIPopoverPresentationControllerDelegate{

    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView?
    
     var searchActive : Bool = false
    
    func parseAddress(selectedItem:MKPlacemark) -> String {
        
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil &&
            selectedItem.thoroughfare != nil) ? " " : ""
        
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) &&
            (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil &&
            selectedItem.administrativeArea != nil) ? " " : ""
        
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        
        return addressLine
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchBar = UISearchBar()
        navigationItem.titleView = searchBar
        searchBar.placeholder = "Search for places"
        searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier ?? "" {
        case SegueIdentifier.showPopupUserPlace:
           preparePromotionPopover(withSegue: segue)
        default:
            return
        }
    }
    
    func preparePromotionPopover(withSegue segue: UIStoryboardSegue) {
        let vc = segue.destination
        let pc = vc.popoverPresentationController
        pc?.sourceRect = CGRect(origin: self.view.center, size: CGSize.zero)
        pc?.delegate = self
        pc?.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }*/
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let mapViews = mapView, searchText != "" else { return }
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchText
        request.region = mapViews.region
        let search = MKLocalSearch(request: request)
        
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if matchingItems.count > 0 {
             return matchingItems.count
        }else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PopUpUserPlace") as! PopUpUserPlace
        vc.handleMapSearchDelegate = AppDelegate.share.mapVC
        vc.placemark = selectedItem
        vc.modalPresentationStyle = UIModalPresentationStyle.custom
        present(vc, animated: true, completion: nil)
    }
}
