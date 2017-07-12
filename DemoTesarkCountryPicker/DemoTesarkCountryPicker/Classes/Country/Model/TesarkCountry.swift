


import Foundation

public func ==(lhs: Country, rhs: Country) -> Bool {
    return lhs.countryCode == rhs.countryCode
}

open class Country: NSObject {
    open static var emptyCountry: Country { return Country(countryCode: "", phoneExtension: "", isMain: true) }
    
    open static var currentCountry: Country {
        if let countryCode = (Locale.current as NSLocale).object(forKey: NSLocale.Key.countryCode) as? String {
            return Countries.countryFromCountryCode(countryCode)
        }
        return Country.emptyCountry
    }
    
    open var countryCode: String
    open var phoneExtension: String
    open var isMain: Bool
    
    public init(countryCode: String, phoneExtension: String, isMain: Bool) {
        self.countryCode = countryCode
        self.phoneExtension = phoneExtension
        self.isMain = isMain
    }
    
    @objc open var name: String {
        let currentLocale : NSLocale = NSLocale.init(localeIdentifier :  NSLocale.current.identifier)
        return currentLocale.displayName(forKey: NSLocale.Key.countryCode, value: countryCode) ?? "Invalid country code"
    }
}


import UIKit

class CountryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countryFlagImageview: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var countryCodeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


