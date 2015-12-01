//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by Luke on 2015/07/28.
//  Copyright (c) 2015年 Luke Tunnicliffe. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    

    
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var deleteButton: UIBarButtonItem!

    var locationArray = [MKPointAnnotation]()

    var deleteOn = false
    var label = UILabel()
    var labelHeight:CGFloat = 60

    @IBAction func deleteButton(sender: AnyObject) {
        if deleteOn == false {
            deleteButton.title = "Done"
            deleteOn = true
            labelMaker()
        }
        else {
            deleteButton.title = "Edit"
            label.removeFromSuperview()
            self.mapView.frame.origin.y = 0
             deleteOn = false
        }
    }

    func action (gestureRecognizer: UIGestureRecognizer) {
        
        if (gestureRecognizer.state == UIGestureRecognizerState.Ended) || (gestureRecognizer.state == UIGestureRecognizerState.Changed){
        
        return
    }
    
            
        else
        {
        
        let touchPoint = gestureRecognizer.locationInView(self.mapView)
            
        let newCoordinate: CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
        let myAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = newCoordinate
         //   myAnnotation.title = "hello"
      //  myAnnotation.title = "Hello"
            saveLocation(myAnnotation)
        self.mapView.addGestureRecognizer(gestureRecognizer)
        refreshAnnotations()
        }
    }
    func refreshAnnotations(){
        mapView.addAnnotations(locationArray)
    }
    override func viewDidLoad() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"saveCurrentRegion:", name:UIApplicationWillTerminateNotification, object:nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"saveCurrentRegion:", name:
            UIApplicationDidEnterBackgroundNotification, object:nil)

        
        super.viewDidLoad()
        refreshAnnotations()
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "action:")
        mapView.addGestureRecognizer(longPressRecognizer)
        
        
        loadSavedRegion()
  

        
    }
    
    func saveCurrentRegion(notification:NSNotification){
        
        
        let currentRegionLatdelta =  mapView.region.span.latitudeDelta
        let currentRegionLongdelta =  mapView.region.span.longitudeDelta
        let currentRegionCenterLatitude =  mapView.region.center.latitude
        let currentRegionCenterLongitude =  mapView.region.center.longitude
        
        
        let defaults = NSUserDefaults.standardUserDefaults()

        defaults.setDouble(currentRegionLatdelta, forKey: "currentRegionLatdelta")
        defaults.setDouble(currentRegionLongdelta, forKey: "currentRegionLongdelta")
        defaults.setDouble(currentRegionCenterLatitude, forKey: "currentRegionCenterLatitude")
        defaults.setDouble(currentRegionCenterLongitude, forKey: "currentRegionCenterLongitude")
  
        
        print("save called")

        
    }
    
    
    func loadSavedRegion(){
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        
        
        let currentRegionLatdelta = defaults.doubleForKey("currentRegionLatdelta")
        let currentRegionLongdelta = defaults.doubleForKey("currentRegionLongdelta")
        let currentRegionCenterLatitude = defaults.doubleForKey("currentRegionCenterLatitude")
        let currentRegionCenterLongitude = defaults.doubleForKey("currentRegionCenterLongitude")
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(currentRegionLatdelta, currentRegionLongdelta)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(currentRegionCenterLatitude, currentRegionCenterLongitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake (location, span)
        
        mapView.setRegion(region, animated:true)


    }
   
    
        func labelMaker() {
        label.frame = CGRectMake(0,self.view.frame.maxY - labelHeight, self.view.frame.width,labelHeight)
        label.text = "Tap Pins to Delete"
        label.backgroundColor = UIColor.redColor()
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
       // self.mapView.removeFromSuperview()
        self.mapView.frame.origin.y = 200
      //  self.view.addSubview(mapView)
        self.view.addSubview(label)

        //This makes the local variable a property in the class. Otherwise label will be an unexpected nil when it is called.
      //  self.label = label
    }
    
    
    

    
//    
//    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
//       
//        var pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
//        pinView.canShowCallout = true
//        //pinView.centerOffset = CGPointMake(100, -200)
//        pinView.pinColor = MKPinAnnotationColor.Green
//        pinView.animatesDrop = true
//        return pinView
//        
//        
//    }

    
        
        
//        if annotation is MKUserLocation {
//            return nil
//        }
//
//        let reuseId = "pin"
//        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
//        if pinView == nil {
//            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//            pinView!.canShowCallout = true
//            pinView!.centerOffset = CGPointMake(10, -20)
//
//
//        }
//        else {
//            pinView!.annotation = annotation
//        }
//        return pinView
//        
        
        
        
//        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
//        annotationView.canShowCallout = false
//        
//        return annotationView
        
   
    
 

    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        
        print("annotation selected")
        
        if deleteOn == true {
         //   println("View to be deleted: \(view)")
          //  println("Array from which to remove items: \(locationArray)")
            
            print("delete is on")
            
          var arrayCounter = 0
           for arrayAnnotation in locationArray{
            print(arrayAnnotation.coordinate.latitude)
            if view.annotation!.coordinate.latitude == arrayAnnotation.coordinate.latitude && view.annotation!.coordinate.longitude == arrayAnnotation.coordinate.longitude {
//                println("Before removal: \(locationArray)")

                locationArray.removeAtIndex(arrayCounter)
                mapView.removeAnnotation(arrayAnnotation)

//                println("After removal: \(locationArray)")
                print("match!")
                return
            }
            arrayCounter++
            }
        }
            
     else  {
            
        //   saveCurrentRegion()
            
        let flickrViewController = self.storyboard!.instantiateViewControllerWithIdentifier("FlickrCollectionViewController") as! FlickrCollectionViewController
        let chosenLatitude: Double = view.annotation!.coordinate.latitude
        let chosenLongitude: Double = view.annotation!.coordinate.longitude
            print(chosenLatitude)
            print(chosenLongitude)

        mapView.deselectAnnotation(view.annotation, animated: true)
        flickrViewController.transferredLatitude = chosenLatitude
        flickrViewController.transferredLongitude = chosenLongitude
      //  self.presentViewController(flickrViewController, animated: true, completion: nil)
        self.navigationController!.pushViewController(flickrViewController, animated: true)
        }


    }
    


}



