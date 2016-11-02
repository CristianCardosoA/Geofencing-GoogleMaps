//
//  utils.swift
//  Example of Geotifications
//
//  Created by MacBook on 31/10/16.
//  Copyright © 2016 iTexico. All rights reserved.
//

import UIKit
import MapKit

protocol AddGeotificationsViewControllerDelegate {
    func addGeotificationViewController(didAddCoordinate: CLLocationCoordinate2D, radius: Double, identifier: String, note: String)
}

extension UIViewController {
    
    func showAlert(withTitle title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithInput(withTitle title: String?, message: String?, delegate: AddGeotificationsViewControllerDelegate?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField { (textField) in
            let placeholder = NSAttributedString(string: "Note", attributes: [NSForegroundColorAttributeName : UIColor.gray])
            textField.attributedPlaceholder = placeholder;
        }
        alert.addTextField { (textField) in
            let placeholder = NSAttributedString(string: "Longitude", attributes: [NSForegroundColorAttributeName : UIColor.gray])
            textField.attributedPlaceholder = placeholder;
        }
        alert.addTextField { (textField) in
            let placeholder = NSAttributedString(string: "Latitude", attributes: [NSForegroundColorAttributeName : UIColor.gray])
            textField.attributedPlaceholder = placeholder;
        }
        
        alert.addTextField { (textField) in
            let placeholder = NSAttributedString(string: "Radius", attributes: [NSForegroundColorAttributeName : UIColor.gray])
            textField.attributedPlaceholder = placeholder;
        }
        
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            let noteText = alert.textFields![0] as UITextField
            let lon = alert.textFields![1] as UITextField
            let lat = alert.textFields![2] as UITextField
            let radiusTe = alert.textFields![3] as UITextField

            let coordinate = CLLocationCoordinate2D(latitude: Double(lat.text!)!, longitude:  Double(lon.text!)!)
            let radius = Double(radiusTe.text!) ?? 0
            let identifier = NSUUID().uuidString
            let note = noteText.text
            
            delegate?.addGeotificationViewController(didAddCoordinate: coordinate, radius: radius, identifier: identifier, note: note!)
        }))
        present(alert, animated: true, completion: nil)
    }
    
}

extension MKMapView {
    func zoomToUserLocation() {
        guard let coordinate = userLocation.location?.coordinate else { return }
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 10000, 10000)
        setRegion(region, animated: true)
    }
}
