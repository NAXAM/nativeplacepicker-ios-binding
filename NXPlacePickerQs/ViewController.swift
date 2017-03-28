//
//  ViewController.swift
//  NXPlacePickerQs
//
//  Created by Vu Tinh on 3/27/17.
//  Copyright © 2017 NAXAM. All rights reserved.
//

import UIKit


class ViewController: UIViewController , NXPlacePickerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        let s = UIStoryboard (
//            name: "Main", bundle: Bundle(for: NXPlacePickerViewController.self)
//        )
//        let vc = s.instantiateInitialViewController() as! NXPlacePickerViewController

        let vc = NXPlacePickerViewController.initWith(nil)
        vc?.delegate = self
        
        self.present(vc!, animated: true, completion: nil)
    }
    
    // NXPlacePickerDelegate
    func placePicker(_ viewController: NXPlacePickerViewController!, didSelectPlace place: MKPlacemark!) {
        print(place)
    }
    
}

