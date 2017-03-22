//
//  PopUpUserPlace.swift
//  DemoPlaceServiceSwift
//
//  Created by Vu Tinh on 3/22/17.
//  Copyright © 2017 Vu Tinh. All rights reserved.
//

import UIKit
import MapKit

class PopUpUserPlace: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var nameLocationLabel: UILabel!
    @IBOutlet weak var addressLocationLabel: UILabel!
    
    weak var handleMapSearchDelegate: HandleMapSearch?
    var placemark : MKPlacemark?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setupMap()
    }
    
    func setupMap() {
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.isUserInteractionEnabled = false
        guard let placemark = placemark else { return}
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func setUpUI() {
        guard let placemark = placemark else { return}
        nameLocationLabel.text = placemark.name
        addressLocationLabel.text = parseAddress(selectedItem: placemark)
        
      /*  self.view.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.insertSubview(blurEffectView, at: 0)*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ActionChangeLocation(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func actionSelectedLocation(_ sender: UIButton) {
        guard let placemark = placemark else { return}
        handleMapSearchDelegate?.dropPinZoomIn(placemark: placemark)
        dismiss(animated: true, completion: nil)
        
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
}
