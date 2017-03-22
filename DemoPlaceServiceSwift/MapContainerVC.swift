//
//  MapContainerVC.swift
//  DemoPlaceServiceSwift
//
//  Created by Vu Tinh on 3/20/17.
//  Copyright © 2017 Vu Tinh. All rights reserved.
//

import UIKit
import MapKit

class MapContainerVC: UIViewController {

    @IBOutlet weak var topBottomSheetConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var viewSearch: UIView!
    
    var topBottomSheetConstant : CGFloat! {
        didSet {
            topBottomSheetConstraint.constant = topBottomSheetConstant
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.isNavigationBarHidden = true
        
        
        viewSearch.layer.cornerRadius = 2
        viewSearch.layer.shadowColor = UIColor.lightGray.cgColor
        viewSearch.layer.shadowOffset = CGSize(width: 0, height: 1)
        viewSearch.layer.shadowRadius = 3
        viewSearch.layer.shadowOpacity = 1
        viewSearch.clipsToBounds = false
        viewSearch.layer.masksToBounds = false
        
        currentLocationButton.layer.cornerRadius = 20
        currentLocationButton.layer.shadowColor = UIColor.lightGray.cgColor
        currentLocationButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        currentLocationButton.layer.shadowRadius = 3
        currentLocationButton.layer.shadowOpacity = 1
        currentLocationButton.clipsToBounds = false
        currentLocationButton.layer.masksToBounds = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier ?? "" {
        case SegueIdentifier.embedMapVC:
            AppDelegate.share.mapVC = segue.destination as? MapVC

        default:
            return
        }
    }
    @IBAction func actionShowCurrentLocation(_ sender: UIButton) {
        var mapView: MKMapView?
        mapView = AppDelegate.share.mapVC?.mapView
        guard let mapview = mapView else {return}
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: mapview.userLocation.coordinate, span: span)
        mapview.setRegion(region, animated: true)
    }

    @IBAction func showSearchPlaceVC(_ sender: UITapGestureRecognizer) {
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        locationSearchTable.mapView = AppDelegate.share.mapVC?.mapView
        let navi = UINavigationController(rootViewController: locationSearchTable)
        self.present(navi, animated: true, completion: nil)
    }

    @IBAction func showSelectThisLocation(_ sender: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: NSNotification.Name("showSelectThisLocation"), object: nil)
    }
    

}
