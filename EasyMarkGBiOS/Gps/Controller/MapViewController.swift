//
//  MapViewController.swift
//  remoteattendance
//
//  Created by Pinlet on 5/28/20.
//  Copyright © 2020 Pinlet. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces
import GoogleMaps
import Reachability

class MapViewController: UIViewController{
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var mapCenterPinImage: UIImageView!
    @IBOutlet weak var hourTxt: UILabel!
    @IBOutlet weak var dateTxt: UILabel!
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
  //  var temp: GMSCoordinateBounds
    var latitude: CLLocationDegrees = -1.831239
    var longitude: CLLocationDegrees = -78.183403
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    
    var delegate: HomeControllerDelegate?
    var ggleMap: GMSMapView?
    var date : Date!
    
    let colorPrimary = "#6200ee"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        } 
        onActive()
        date = Date()
        configureDateLabel()
        configureNavigationBar()
          
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
            
        } else {
          locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "mapSegue",
           let destinationVC = segue.destination as? RegisterController {
               print("Hello World Register !!")
            
            destinationVC.delegate = self.delegate
            let centerController = UINavigationController(rootViewController: destinationVC)
            
            view.addSubview(centerController.view)
            addChild(centerController)
            centerController.didMove(toParent: self)
        }
        
    }
    
    
    @objc func handleMenuToggle() {
        delegate?.handleMenuToggle(forMenuOption: nil)
    }
    

    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor(hexString: colorPrimary)
        navigationController?.navigationBar.barStyle = .black
        
        let titleBarLbl: UILabel = {
            let label = UILabel()
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 21)
            label.text = "Reloj Online"
            return label
        }()
        navigationItem.titleView = titleBarLbl
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
    }
    
    func configureDate() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm"
        let formattedDate = format.string(from: self.date)
        return formattedDate
    }
    
    func getHourFromFormattedDate(formDate: String) -> String {
        let fullDateArr = formDate.components(separatedBy: " ")

        let fullHourArr = fullDateArr[1].components(separatedBy: ":")
        let hourStr = fullHourArr[0]
        return hourStr
    }
    
    func getMinFromFormattedDate(formDate: String) -> String {
        let fullDateArr = formDate.components(separatedBy: " ")

        let fullHourArr = fullDateArr[1].components(separatedBy: ":")
        let minStr = fullHourArr[1]
        return minStr
    }
    
    func getDayFromFormattedDate(formDate: String) -> String {
        let fullDateArr = formDate.components(separatedBy: " ")

        let fullCalendarArr = fullDateArr[0].components(separatedBy: "-")
        let dayStr = fullCalendarArr[2]
        return dayStr
    }
    
    func getMonthFromFormattedDate(formDate: String) -> String {
        let fullDateArr = formDate.components(separatedBy: " ")

        let fullCalendarArr = fullDateArr[0].components(separatedBy: "-")
        let monthStr = fullCalendarArr[1]
        return monthStr
    }
    
    func getYearFromFormattedDate(formDate: String) -> String {
        let fullDateArr = formDate.components(separatedBy: " ")

        let fullCalendarArr = fullDateArr[0].components(separatedBy: "-")
        let yearStr = fullCalendarArr[0]
        return yearStr
    }
    
    func configureDateLabel(){
        let today = configureDate()
        hourTxt.text = "\(getHourFromFormattedDate(formDate: today)):\(getMinFromFormattedDate(formDate: today))"
        
        dateTxt.text = "\(getYearFromFormattedDate(formDate: today))-\(getMonthFromFormattedDate(formDate: today))-\(getDayFromFormattedDate(formDate: today))"
    }
    
    
    func onActive(){
        let state = UIApplication.shared.applicationState
        if state == .active {
           print("I'm active")
        } else{
            print("I'm a BAD INACTIVE APPLICATION !!! ")
        }
    }
}


extension MapViewController : GMSAutocompleteViewControllerDelegate{
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
                
        print("Place name: \(String(describing: place.name))")
        print("Place ID: \(String(describing: place.placeID))")
        print("Place attributions: \(String(describing: place.attributions))")
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error.")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Was Canceled.")
    }
    
}


extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
    
        /*locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()*/
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
       // print("LOCATION MANAGER: \(locationManager)")
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    /*guard let location = locations.first else {
      return
    }*/
      
      guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
          //print("locations = \(locValue.latitude) \(locValue.longitude)")
          AppSettings.latitude = String(locValue.latitude)
          AppSettings.longitude = String(locValue.longitude)
    
        mapView.camera = GMSCameraPosition(
          target: locValue,
          zoom: 15,
          bearing: 0,
          viewingAngle: 0)
    //fetchPlaces(near: location.coordinate)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
  }
    
}
