

import UIKit

public protocol TesarkCountriesViewControllerDelegate {
    func countriesViewControllerDidCancel()
    func countriesViewController(didSelectCountry country: Country)
}

public final class TesarkCountriesViewController: UITableViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    public class func standardController() -> TesarkCountriesViewController {
        return UIStoryboard(name: "TesarkCountrypicker", bundle: Bundle(for: self)).instantiateViewController(withIdentifier: "Countries") as! TesarkCountriesViewController
    }
    
    @IBOutlet weak public var cancelBarButtonItem: UIBarButtonItem!
    public var cancelBarButtonItemHidden = false { didSet { setupCancelButton() } }
    
    fileprivate func setupCancelButton() {
        if let cancelBarButtonItem = cancelBarButtonItem {
            navigationItem.leftBarButtonItem = cancelBarButtonItemHidden ? nil: cancelBarButtonItem
        }
    }
    
    fileprivate var searchController = UISearchController(searchResultsController: nil)
    
    public var unfilteredCountries: [[Country]]! { didSet { filteredCountries = unfilteredCountries } }
    public var filteredCountries: [[Country]]!
    
    public var selectedCountry: Country?
    public var majorCountryLocaleIdentifiers: [String] = []
    
    public var delegate: TesarkCountriesViewControllerDelegate?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        majorCountryLocaleIdentifiers.append(Locale.current.regionCode!)

        if Locale.current.regionCode! != "IN" {
            majorCountryLocaleIdentifiers.append("IN")
        }
        if Locale.current.regionCode! != "AE" {
            majorCountryLocaleIdentifiers.append("AE")
        }
        

        
        setupCancelButton()
        
        setupCountries()
        setupSearchController()
        self.tableView.setContentOffset(CGPoint.zero, animated: true)
        
        // navigationController!.navigationBar.barTintColor = Color.Theme
        //navigationController!.navigationBar.tintColor = Color.PrimaryWhite
        //navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: Font.medium.of(size: 18.0), NSForegroundColorAttributeName: Color.PrimaryWhite]
        
       
        

    }
    
    //MARK: Searching Countries
    fileprivate func setupSearchController() {
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.navigationController?.setNavigationBarHidden(true, animated: false)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.backgroundColor = UIColor.white

        //searchController.searchBar.barTintColor = Color.Theme
        //searchController.searchBar.tintColor = Color.PrimaryWhite
        //searchController.searchBar.backgroundColor = Color.Theme
       
        
        
        tableView.tableHeaderView = searchController.searchBar
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        definesPresentationContext = true
    }
    
    public func willPresentSearchController(_ searchController: UISearchController) {
        tableView.reloadSectionIndexTitles()
    }
    
    public func willDismissSearchController(_ searchController: UISearchController) {
        tableView.reloadSectionIndexTitles()
    }
    
    public func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text ?? ""
        searchForText(searchString)
        tableView.reloadData()
    }
    
    fileprivate func searchForText(_ text: String) {
        if text.isEmpty {
            filteredCountries = unfilteredCountries
        } else {
            let allCountries: [Country] = Countries.countries.filter { $0.name.range(of: text) != nil }
            filteredCountries = partionedArray(allCountries, usingSelector: #selector(getter: Country.name))
            filteredCountries.insert([], at: 0) //Empty section for our favorites
        }
        tableView.reloadData()
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        filteredCountries = unfilteredCountries
//        tableView.reloadData()
    }
    
    //MARK: Viewing Countries
    fileprivate func setupCountries() {
        
        tableView.sectionIndexTrackingBackgroundColor = UIColor.clear
        tableView.sectionIndexBackgroundColor = UIColor.clear
        
        unfilteredCountries = partionedArray(Countries.countries, usingSelector: #selector(getter: Country.name))
        unfilteredCountries.insert(Countries.countriesFromCountryCodes(majorCountryLocaleIdentifiers), at: 0)
        tableView.reloadData()
        
        if let selectedCountry = selectedCountry {
            for (index, countries) in unfilteredCountries.enumerated() {
                if let countryIndex = countries.index(of: selectedCountry) {
                    let indexPath = IndexPath(row: countryIndex, section: index)
                    tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
                    break
                }
            }
        }
    }
    
    //MARK:
    //MARK: Delegate and Data source  for Tableview
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return filteredCountries.count
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))

            noDataLabel.text          = "No data available"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
       
        return filteredCountries[section].count
    }
    
    
    
   override public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        tableView.backgroundView = nil
    }
    override public  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell") as! CountryTableViewCell
        
        let country = filteredCountries[indexPath.section][indexPath.row]
        
       let  path = Bundle.main.path(forResource: "country", ofType: "bundle")
        if path != nil { 
            cell.countryFlagImageview.image = UIImage.init(named: "country.bundle/\(country.countryCode.lowercased())")
            
            
        }
        
        
        
        
        
        cell.countryNameLabel.text = country.name
        cell.countryCodeLabel.text = "+" + country.phoneExtension
        
        cell.accessoryType = .none
        
        if let selectedCountry = selectedCountry, country == selectedCountry {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    override public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let countries = filteredCountries[section]
        if countries.isEmpty  {
            return nil
        }
        
        if section == 0 {
            return nil
        }
       
        return UILocalizedIndexedCollation.current().sectionTitles[section - 1]
    }
    
    public override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return searchController.isActive ? nil : UILocalizedIndexedCollation.current().sectionTitles
    }
    
    public override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return UILocalizedIndexedCollation.current().section(forSectionIndexTitle: index + 1)
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        self.searchController.navigationController?.setNavigationBarHidden(true, animated: false)

        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.countriesViewController(didSelectCountry: filteredCountries[indexPath.section][indexPath.row ])
    }
    
    //MARK: Navigation Bar Cancel Button Action
    @IBAction fileprivate func cancel(_ sender: UIBarButtonItem) {
        delegate?.countriesViewControllerDidCancel()

    }
}

//MARK: Prepare Country array objects 
private func partionedArray<T: AnyObject>(_ array: [T], usingSelector selector: Selector) -> [[T]] {
    let collation = UILocalizedIndexedCollation.current() 
    let numberOfSectionTitles = collation.sectionTitles.count
    
    var unsortedSections: [[T]] = Array(repeating: [], count: numberOfSectionTitles)
    for object in array {
        let sectionIndex = collation.section(for: object, collationStringSelector: selector)
        unsortedSections[sectionIndex].append(object)
    }
    
    var sortedSections: [[T]] = []
    for section in unsortedSections {
        let sortedSection = collation.sortedArray(from: section, collationStringSelector: selector) as! [T]
        sortedSections.append(sortedSection)
    }
    return sortedSections
}
