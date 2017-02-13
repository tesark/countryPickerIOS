# countryPickeriOS

# Purpose 

      - Can pick country details  
        ( Framework has Flexible UI & Controller )
      - Current Location based Country Picker

# variable for showcase 

    @IBOutlet weak var TesarkcountryNameLabel: UILabel!
    @IBOutlet weak var TesarkcountryDialcodeLabel: UILabel!
    @IBOutlet weak var TesarkcountryCodeLabel: UILabel!

#  Method for Call county view UI
    
    @IBAction func ButtonACtion_chooseCountrycode(_ sender: Any) {
    
        let countriesViewController = TesarkCountriesViewController.standardController()
        countriesViewController.delegate = self
        navigationController?.pushViewController(countriesViewController, animated: true)
        
    }
    
  # Delegate Init and Delegate Methods
  
    class ViewController: UIViewController, TesarkCountriesViewControllerDelegate {
      ........
    }

 # TesarkCountriesViewControllerDelegate for Cancel
 
     func countriesViewControllerDidCancel() {
     
        _ = self.navigationController?.popViewController(animated: true)
        
     }
    
   #  TesarkCountriesViewControllerDelegate for Selcted Country Details

        func countriesViewController(didSelectCountry country: Country) {
        
            _ = self.navigationController?.popViewController(animated: true)
            TesarkcountryNameLabel.text = country.name
            TesarkcountryDialcodeLabel.text = "+ \(country.phoneExtension)"
             TesarkcountryCodeLabel.text = country.countryCode
            self.title = country.name

          }


# Demo Screens

![alt tag](https://github.com/tesark/countryPickerIOS/blob/master/Choose%20Country.gif)
