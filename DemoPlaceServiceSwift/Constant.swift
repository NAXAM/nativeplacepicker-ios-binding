//
//  Constant.swift
//  DemoPlaceServiceSwift
//
//  Created by Vu Tinh on 3/20/17.
//  Copyright © 2017 Vu Tinh. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let displayingModeDidChange                 = Notification.Name("displayingModeDidChange")
    
}

struct SegueIdentifier {
    static let embedMapVC                       = "embedMapVC"
    static let embedSearchPlaceVC               = "embedSearchPlaceVC"
    static let showLocationSearch = "showLocationSearch"
    static let showPopupUserPlace = "showPopupUserPlace"
}
