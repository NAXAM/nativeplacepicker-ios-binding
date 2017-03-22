//
//  SearchPlaceVC.swift
//  DemoPlaceServiceSwift
//
//  Created by Vu Tinh on 3/20/17.
//  Copyright © 2017 Vu Tinh. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AddressBookUI

class SearchPlaceVC: BaseBottomMenuVC, UITableViewDelegate, UITableViewDataSource , CLLocationManagerDelegate{
    
    weak var handleMapSearchDelegate: HandleMapSearch?
    var matchingItems: [CLPlacemark] = []
    var mapView: MKMapView?
    var locationManager = CLLocationManager()
    
    static var identifier = "SearchPlaceVC"
    static var instance : SearchPlaceVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: SearchPlaceVC.identifier) as! SearchPlaceVC
    }
    
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
        navigationController?.isNavigationBarHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        mapView = AppDelegate.share.mapVC?.mapView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //CLLocationManagerDelegate
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        } else if status == .authorizedAlways {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        getPlacemarkFromLocation(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
    func getPlacemarkFromLocation(location: CLLocation){
        CLGeocoder().reverseGeocodeLocation(location, completionHandler:
            {(placemarks, error) in
                if (error != nil) {print("reverse geodcode fail: \(error?.localizedDescription)")}
                let pm = placemarks! as [CLPlacemark]
                    self.matchingItems = pm
                    self.tableView.reloadData()
        })
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let selectedItem = matchingItems[indexPath.row]
        
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = "\(selectedItem.locality!) ,\(selectedItem.country!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row]
//        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem as! MKPlacemark)
        NotificationCenter.default.post(name: NSNotification.Name.init("showPopover"), object: selectedItem)
    }
    
}
