//
//  BaseBottomMenuVC.swift
//  DemoPlaceServiceSwift
//
//  Created by Vu Tinh on 3/20/17.
//  Copyright © 2017 Vu Tinh. All rights reserved.
//

import UIKit

class BaseBottomMenuVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    unowned var transformNAV: TransformNavigationController = TransformNavigationController()
    
    weak var mapVC: MapVC?
    var topConstant: CGFloat! {
        set {
            transformNAV.topConstant = newValue
        }
        get {
            return transformNAV.topConstant
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerNotification()
        if let transformNAV = (navigationController as? TransformNavigationController) {
            self.transformNAV = transformNAV
            mapVC = transformNAV.mapVC
        }
    }
    
    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(navigationControllerDidChangeDisplayingMode), name: .displayingModeDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func navigationControllerDidChangeDisplayingMode() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension BaseBottomMenuVC {
    
    @IBAction func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        guard isEditing != true    else {return}
        transformNAV.handlePanGesture(sender: sender, tableView: tableView)
    }
}

extension BaseBottomMenuVC: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        transformNAV.disableTableViewScrollIfNeed(tableView: tableView, gestureRecognizer: gestureRecognizer)
        return false
    }
}
