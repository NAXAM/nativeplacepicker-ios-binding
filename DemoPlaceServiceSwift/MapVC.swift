//
//  MapVC.swift
//  DemoPlaceServiceSwift
//
//  Created by Vu Tinh on 3/20/17.
//  Copyright © 2017 Vu Tinh. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol HandleMapSearch: class {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class MapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate , HandleMapSearch{
 
    @IBOutlet weak var mapContainer: MapContainerVC!
    
    @IBOutlet weak var mapView: MKMapView!
   
    var selectedPin: MKPlacemark?
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: NSNotification.Name.init("showPopover"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSelectThisLocation), name: NSNotification.Name("showSelectThisLocation"), object: nil)
    }
    
    func handleNotification(notification: Notification){
         let notificatio = notification.object as! CLPlacemark
        
        let placemark = MKPlacemark(placemark: notificatio)
        
        //dropPinZoomIn(placemark: placemark)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PopUpUserPlace") as! PopUpUserPlace
        vc.handleMapSearchDelegate = self
        vc.placemark = placemark
        
        vc.modalPresentationStyle = UIModalPresentationStyle.custom
        present(vc, animated: true, completion: nil)
    }
    
    func handleSelectThisLocation() {
        guard let selectedPin = selectedPin else {return}
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PopUpUserPlace") as! PopUpUserPlace
        vc.handleMapSearchDelegate = self
        vc.placemark = selectedPin
        vc.modalPresentationStyle = UIModalPresentationStyle.custom
        present(vc, animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func getDirections(){
        guard let selectedPin = selectedPin else { return }
        let mapItem = MKMapItem(placemark: selectedPin)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier ?? "" {
        case SegueIdentifier.showLocationSearch:
            AppDelegate.share.mapVC = segue.destination as? MapVC
        //            AppDelegate.share.mapVC?.mapContainer = self
        default:
            return
        }
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
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        getPlacemarkFromLocation(location: location)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
    func getPlacemarkFromLocation(location: CLLocation){
        CLGeocoder().reverseGeocodeLocation(location, completionHandler:
            {(placemarks, error) in
                if (error != nil) {print("reverse geodcode fail: \(error?.localizedDescription)")}
                let pm = placemarks! as [CLPlacemark]
                //self.matchingItems = pm
                
                let mkPlacemark = MKPlacemark(placemark: pm.first!)
                self.selectedPin = mkPlacemark
                for item in pm {
                    let mkPlacemark = MKPlacemark(placemark: item)
                    self.dropPinZoomIn(placemark: mkPlacemark)
                }
        })
    }

    
    //MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        
        guard !(annotation is MKUserLocation) else { return nil }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), for: .normal)
        button.addTarget(self, action: #selector(MapVC.getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        
        return pinView
    }
    
    
    //HandleMapSearch
    func dropPinZoomIn(placemark: MKPlacemark) {
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}
