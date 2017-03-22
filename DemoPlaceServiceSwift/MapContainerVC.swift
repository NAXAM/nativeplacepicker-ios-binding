//
//  MapContainerVC.swift
//  DemoPlaceServiceSwift
//
//  Created by Vu Tinh on 3/20/17.
//  Copyright © 2017 Vu Tinh. All rights reserved.
//

import UIKit

class MapContainerVC: UIViewController {

    @IBOutlet weak var topBottomSheetConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomSheetViewConstraint: NSLayoutConstraint!
    
    var topBottomSheetConstant : CGFloat! {
        didSet {
            topBottomSheetConstraint.constant = topBottomSheetConstant
        }
    }
    
    var bottomSheetViewConstant : CGFloat! {
        didSet {
            bottomSheetViewConstraint.constant = bottomSheetViewConstant
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.isNavigationBarHidden = true
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
//            AppDelegate.share.mapVC?.mapContainer = self
            
        case SegueIdentifier.embedSearchPlaceVC:
            let searchVC = segue.destination as? SearchPlaceVC
        default:
            return
        }
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
