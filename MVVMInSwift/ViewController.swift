//
//  ViewController.swift
//  MVVMInSwift
//
//  Created on 6/8/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    /// The data model itself
    /// This is only for prototype
    /// Any production code should NOT refer model in the view
    /// The purpose of MVVM is to COMPLETELY ISOLATE MODEL FROM VIEW
    /// Any message from model to view and vice versa is through the viewmodel
    var model : Model?
    
    // Two view models
    // In real life, the two view models must be in different classes
    // Each use a different observing strategy, and a different delegation
    // of the properties and methods to the model.
    
    /// The view model responsible for modifying the UI
    var viewModel : ViewModel?
    /// The view model that prints the changes
    var viewModelForPrinting : ViewModel?
    
    // MARK: - The observation contexts
    var uiObservation = 0
    var printingObservation = 0
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var balanceField: UITextField!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create the model
        model = Model()
        // Create the viewmodels observing on the same model
        viewModel = ViewModel(model: model!)
        viewModelForPrinting = ViewModel(model: model!)
        // The one who prints values, has the factor of 2
        // To show how the value can change in two forms if change happens
        viewModelForPrinting?.factor = 2.0
        
        // Add observation
        viewModel?.addObserver(self, forKeyPath: #keyPath(ViewModel.name), options: .init(rawValue: 0), context: &uiObservation)
        viewModel?.addObserver(self, forKeyPath: #keyPath(ViewModel.address), options: .init(rawValue: 0), context: &uiObservation)
        viewModel?.addObserver(self, forKeyPath: #keyPath(ViewModel.balance), options: .init(rawValue: 0), context: &uiObservation)
        viewModelForPrinting?.addObserver(self, forKeyPath: #keyPath(ViewModel.name), options: .init(rawValue: 0), context: &printingObservation)
        viewModelForPrinting?.addObserver(self, forKeyPath: #keyPath(ViewModel.address), options: .init(rawValue: 0), context: &printingObservation)
        viewModelForPrinting?.addObserver(self, forKeyPath: #keyPath(ViewModel.balance), options: .init(rawValue: 0), context: &printingObservation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Text field delegate
    
    // No validation in the view here
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameField {
            viewModel?.name = textField.text ?? ""
        } else if textField == addressField {
            viewModel?.address = textField.text ?? ""
        } else if textField == balanceField {
            viewModel?.balance = Double.init(textField.text ?? "") ?? 0.0
        }
    }
    
    // MARK: - Actions

    @IBAction func action(_ sender: Any) {
        viewModel?.name = nameField.text ?? ""
        viewModel?.address = addressField.text ?? ""
        viewModel?.balance = Double.init(balanceField.text ?? "") ?? 0.0
    }
    
    // MARK: - Observation
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // Note: this observation is on the viewmodel, not on the model itself
        // UI Observation
        if context == &uiObservation {
            // Each property change, change its textField and label texts
            switch keyPath! {
            case #keyPath(ViewModel.name):
                nameField.text = viewModel?.name
                nameLabel.text = viewModel?.name
            case #keyPath(ViewModel.address):
                addressField.text = viewModel?.address
                addressLabel.text = viewModel?.address
            case #keyPath(ViewModel.balance):
                balanceField.text = "\(viewModel?.balance ?? 0.0)"
                balanceLabel.text = "\(viewModel?.balance ?? 0.0)"
            default: break
            }
        } else if context == &printingObservation {
            // The other observation, the printing one
            // Just print the changes, to show that different viewmodels can observe the same model
            // Use it when you want to display data in two different views
            // Each view views the model from a different point of view
            print("\(keyPath!) is changed to \( viewModelForPrinting?.value(forKey: keyPath!) ?? "NIL" )")
        } else {
            // If not handled, go to the default one
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }


}

