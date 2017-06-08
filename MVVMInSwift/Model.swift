//
//  Model.swift
//  MVVMInSwift
//
//  Created on 6/8/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

/// The data model
class Model: NSObject {
    // The properties here are dynamic
    // See: https://developer.apple.com/library/content/documentation/Swift/Conceptual/BuildingCocoaApps/AdoptingCocoaDesignPatterns.html#//apple_ref/doc/uid/TP40014216-CH7-ID12
    @objc dynamic var name : String = ""
    @objc dynamic var address : String = ""
    @objc dynamic var balance : Double = 0.0
}
