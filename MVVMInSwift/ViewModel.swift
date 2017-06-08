//
//  ViewModel.swift
//  MVVMInSwift
//
//  Created on 6/8/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

/// The view model only is a middleware, it only marshal messages from the view to the
/// model, and observe on any change in the model to notify all who observe on it itself
class ViewModel: NSObject {
    
    /// The backend model object
    let model : Model
    
    /// The context for Key Value observation
    var context = 0
    
    /// Initializes the view model
    ///
    /// - Parameter model: The model to watch and edit
    init(model : Model) {
        self.model = model
        super.init()
        // Add observation for the three properties
        // .prior, means there is 2 notifications, one before property change
        //   and another after it
        model.addObserver(self, forKeyPath: #keyPath(Model.name), options: [.prior], context: &context)
        model.addObserver(self, forKeyPath: #keyPath(Model.address), options: [.prior], context: &context)
        model.addObserver(self, forKeyPath: #keyPath(Model.balance), options: [.prior], context: &context)
    }
    
    deinit {
        // On deallocation, remove observation from those properties
        model.removeObserver(self, forKeyPath: #keyPath(Model.name))
        model.removeObserver(self, forKeyPath: #keyPath(Model.address))
        model.removeObserver(self, forKeyPath: #keyPath(Model.balance))
    }
    
    /// A factor, to show that different view models can make different "point of views"
    /// for the same models
    var factor : Double = 1.0
    
    /// name property
    /// Just delegates to the model, with validation
    @objc dynamic var name : String {
        get { return model.name }
        set(value) { if (!value.isEmpty) { model.name = value } }
    }
    
    /// address property
    /// Just delegates to the model
    @objc dynamic var address : String {
        get { return model.address }
        set(value) { model.address = value }
    }
    
    /// balance property
    /// Just delegates to the model
    @objc dynamic var balance : Double {
        get { return model.balance * factor }
        set(value) { model.balance = value / factor }
    }
    
    // Make the properties not automatic, well, there is not variable for the property
    // Automatic means when changed, it is notified directly, we don't want that
    // We want that when change property of the model, notify any observe
    override class func automaticallyNotifiesObservers(forKey key: String) -> Bool {
        if key == #keyPath(Model.name) {
            return false
        }
        if key == #keyPath(Model.address) {
            return false
        }
        if key == #keyPath(Model.balance) {
            return false
        }
        return true
    }

    
    // The observer function
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // The context is what we defined for the three properties?
        if context == &self.context {
            // If the notification is prior (i.e. will change)
            if change?[.notificationIsPriorKey] as? Bool == true {
                print("model's \(keyPath!) is changing")
                // Just notify any observer that this property is changing
                // If you want some filteration, do it here,
                // i.e. another viewmodel that don't care about name, would not
                //   notify observer about name
                willChangeValue(forKey: keyPath!)
            } else {
                print("model's \(keyPath!) is changed")
                // Just notify any observer that the property is changed
                // Another filteration can go here to
                didChangeValue(forKey: keyPath!)
            }
        } else {
            // Another property?, call the default
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    
}
