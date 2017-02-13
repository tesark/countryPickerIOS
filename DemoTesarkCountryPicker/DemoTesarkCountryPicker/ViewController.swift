//
//  ViewController.swift
//  DemoTesarkCountryPicker
//
//  Created by Mac Mini on 13/02/17.
//  Copyright © 2017 Mac Mini. All rights reserved.
//

import UIKit
import TesarkCountryPicker

class ViewController: UIViewController, TesarkCountriesViewControllerDelegate {

    @IBOutlet weak var TesarkcountryNameLabel: UILabel!
    @IBOutlet weak var TesarkcountryDialcodeLabel: UILabel!
    @IBOutlet weak var TesarkcountryCodeLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Method for Call county view UI
    
    @IBAction func ButtonACtion_chooseCountrycode(_ sender: Any) {
        let countriesViewController = TesarkCountriesViewController.standardController()
        countriesViewController.delegate = self
        navigationController?.pushViewController(countriesViewController, animated: true)
    }
    //MARK: TesarkCountriesViewControllerDelegate for Cancel
    func countriesViewControllerDidCancel() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: TesarkCountriesViewControllerDelegate for Selcted Country Details

    func countriesViewController(didSelectCountry country: Country) {
        _ = self.navigationController?.popViewController(animated: true)
        TesarkcountryNameLabel.text = country.name
        TesarkcountryDialcodeLabel.text = "+ \(country.phoneExtension)"
        TesarkcountryCodeLabel.text = country.countryCode
        self.title = country.name

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

