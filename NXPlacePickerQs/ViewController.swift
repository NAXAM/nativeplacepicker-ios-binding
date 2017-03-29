//
//  ViewController.swift
//  NXPlacePickerQs
//
//  Created by Vu Tinh on 3/27/17.
//  Copyright © 2017 NAXAM. All rights reserved.
//

import UIKit
import AddressBookUI

class ViewController: UIViewController , NXPlacePickerDelegate{

    @IBOutlet weak var btnPickPlace: UIButton!
    @IBOutlet weak var lblSelectedPlace: UILabel!
    
    @IBAction func doPickPlace(_ sender: UIButton) {
        let vc = NXPlacePickerViewController.initWith(self)
        
        self.present(vc, animated: true, completion: nil)
    }
    
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
    }
    
    // NXPlacePickerDelegate
    func placePicker(_ viewController: NXPlacePickerViewController, didSelectPlace place: MKPlacemark) {
        viewController.dismiss(animated: true, completion: nil)
        lblSelectedPlace.text = ABCreateStringWithAddressDictionary(place.addressDictionary!, false)
        print(place)
    }
    
}

