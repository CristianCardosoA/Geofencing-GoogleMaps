//
//  ViewController.swift
//  Geofencing-GoogleMaps
//
//  Created by MacBook on 01/11/16.
//  Copyright © 2016 iTexico. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import CoreData

var isCustomViewOpen = false


class ViewController: UIViewController , GMSMapViewDelegate{
    
    var delegateAddGeotification: AddGeotificationsViewControllerDelegate?

    var context : NSManagedObjectContext? = nil
    
    var locationManager = CLLocationManager()
    
    var map : GMSMapView? = nil

    var geotifications: [Geotification] = []
    
    @IBOutlet var mapView: UIView!
    
    @IBAction func add(_ sender: AnyObject) {
        
        showAlertWithInput(withTitle: "Add a geotification", message: "", delegate:  delegateAddGeotification)

    }
    
    @IBAction func currentLocation(_ sender: AnyObject) {
        
        if let myLoc = map?.myLocation{
            let camera = GMSCameraPosition.camera(withLatitude: (myLoc.coordinate.latitude),
                                                  longitude:(myLoc.coordinate.longitude), zoom: 10)
            map?.animate(to: camera)
        }
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegateAddGeotification = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        context = appDelegate.persistentContainer.viewContext
        
        // Do any additional setup after loading the view, typically from a nib.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86,
                                                          longitude:151.20, zoom: 8)
        map = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 100), camera: camera)
        
        map?.delegate = self
        map?.tag = 101 //map
        map?.isMyLocationEnabled = true
        map?.settings.myLocationButton = true
        self.mapView.addSubview(map!)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(-33.86, 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.icon = UIImage(named: "point.png")
        marker.map = map
    
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        loadAllGeotifications()
        
    }
    
    func showLifeEventView(anotation : GMSMarker){
        
        let image : UIImage = UIImage(named:"grandma.jpg")!
        let customView = CustomViewController.initWithGeotification(name: (anotation as! Geotification).note, bio : "bio", image: image, frame: CGRect(x: 0, y: view.frame.size.height - (view.frame.size.height * 0.420) , width: self.view.frame.width, height: (view.frame.size.height * 0.420) ))
        
        if !isCustomViewOpen {
            isCustomViewOpen = true
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
                self.view.addSubview(customView)
                self.view.layoutIfNeeded()
                }, completion: nil)
            
        }
        
        let tapGesture = CustomTapGestureRecognizer(target:self, action: #selector(ViewController.removeSubview(customTap:)))
        tapGesture.markerView = anotation
        anotation.icon = UIImage(named: "focus.png")
        customView.addGestureRecognizer(tapGesture)
    }
    
    func removeSubview( anotation : GMSMarker){
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
            isCustomViewOpen = false
            anotation.icon = UIImage(named: "point.png")
        }
    }
    
    func removeSubview(customTap : CustomTapGestureRecognizer){
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
            isCustomViewOpen = false
            customTap.markerView?.icon = UIImage(named: "point.png")
        }
    }
    
    func loadAllGeotifications() {
        
        geotifications = []
        
        /*guard let savedItems = UserDefaults.standard.array(forKey: PreferencesKeys.savedItems) else { return }
         
         for savedItem in savedItems {
         guard let geotification = NSKeyedUnarchiver.unarchiveObject(with: savedItem as! Data) as? Geotification else { continue }
         add(geotification: geotification)
         }*/
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "Geotification")
        request.returnsObjectsAsFaults = false
        
        do{
            
            let results = try context?.fetch(request)
            
            if (results?.count)! > 0 {
                
                for result in results as! [NSManagedObject]{
                    
                    let latitude = result.value(forKey: "latitude") as? Double
                    let longitude = result.value(forKey: "longitude") as? Double
                    let radius = result.value(forKey: "radius") as? Double
                    let note = result.value(forKey: "note") as? String
                    let identifier = result.value(forKey: "identifier") as? String
                    
                    add(geotification: Geotification(coordinate: CLLocationCoordinate2DMake(latitude!, longitude!), radius: radius!, identifier: identifier!, note: note!))
                }
                
            } else{
                print("No results")
            }
            
        } catch {
            print("Couldnt fetch results")
            
        }
    }

    
    func startMonitoring(geotification: Geotification) {
        
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            showAlert(withTitle:"Error", message: "Geofencing is not supported on this device!")
            return
        }
        
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            showAlert(withTitle:"Warning", message: "Your geotification is saved but will only be activated once you grant Geotify permission to access the device location.")
        }
        
        let region = self.region(withGeotification: geotification)
        
        locationManager.startMonitoring(for: region)
    }
    
    func add(geotification: Geotification) {
        geotifications.append(geotification)
        geotification.position = geotification.coordinate
        geotification.title = "Sydney"
        geotification.snippet = "Australia"
        geotification.icon = UIImage(named: "point.png")
        geotification.map = self.map
    }
    
    func region(withGeotification geotification: Geotification) -> CLCircularRegion {
        
        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
        region.notifyOnEntry = true //ON ENTER PUSH NOTIFICATION
        return region
    }
    
    func saveAllGeotifications() {
        
        for geotification in geotifications {
            let newGeotification = NSEntityDescription.insertNewObject(forEntityName: "Geotification", into: self.context!)
            
            newGeotification.setValue(geotification.coordinate.latitude, forKey: "latitude")
            newGeotification.setValue(geotification.coordinate.longitude, forKey: "longitude")
            newGeotification.setValue(geotification.note, forKey: "note")
            newGeotification.setValue(geotification.radius, forKey: "radius")
            newGeotification.setValue(geotification.identifier, forKey: "identifier")
            
            do{
                try context?.save()
                print("Saved")
                
            } catch {
                print("Was an error")
            }
            
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        showLifeEventView(anotation: marker)
        return true
    }

    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        //mapView.clear()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
}

extension ViewController: AddGeotificationsViewControllerDelegate {
    
    func addGeotificationViewController(didAddCoordinate: CLLocationCoordinate2D, radius: Double, identifier: String, note: String){
        
        
        let clampedRadius = min(radius, locationManager.maximumRegionMonitoringDistance)
        let geotification = Geotification(coordinate: didAddCoordinate, radius: clampedRadius, identifier: identifier, note: note)
        
        showAlert(withTitle: "Geotification Added", message: note)
        
        add(geotification: geotification)
        startMonitoring(geotification: geotification)
        saveAllGeotifications()
        
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed with the following error: \(error)")
    }
}



