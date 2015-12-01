//
//  SavePins.swift
//  Virtual Tourist
//
//  Created by Luke on 2015/12/01.
//  Copyright © 2015年 Luke Tunnicliffe. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import CoreData

extension MapViewController {
    
    

    
    func saveLocation(annotation:MKPointAnnotation) {
        
        locationArray.append(annotation)
        
        savePlace(annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)

        for annotation in locationArray {
            
            
            
            
            print(annotation.coordinate.latitude)
            print(annotation.description)
        }
    }
    
    
    func savePlace(latitude:Double,longitude:Double){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Locations", inManagedObjectContext: managedContext!)
        
        let location = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        
        
        location.setValue(latitude, forKey: "latitude")
        location.setValue(longitude, forKey: "longitude")

        
        do {
            try managedContext!.save()
            
            locations.append(location)
            
            
        } catch let error as NSError {
            
            print("Could not save \(error), \(error.userInfo)")
            
        }
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Locations")
        
        do {
            let results = try managedContext!.executeFetchRequest(fetchRequest)
            locations = results as! [NSManagedObject]
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
    func addSavedLocations(){
        
        for location in locations {
            
            let latitude = location.valueForKey("latitude") as? Double
            let longitude = location.valueForKey("longitude") as? Double
            
            let newAnnotation = MKPointAnnotation()
            newAnnotation.coordinate.longitude = longitude!
            newAnnotation.coordinate.latitude = latitude!
            mapView.addAnnotation(newAnnotation)
            
            print("Save locations called!")
            

        }

        
        
    }
    
    
    
    
}
