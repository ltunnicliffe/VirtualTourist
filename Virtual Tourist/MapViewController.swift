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

    
    
    var defaults = NSUserDefaults.standardUserDefaults()

    
    
    
    
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
      //  println(locationArray)
    }

    func action (gestureRecognizer: UIGestureRecognizer) {
        
        if (gestureRecognizer.state == UIGestureRecognizerState.Ended) || (gestureRecognizer.state == UIGestureRecognizerState.Changed){
        
        return
    }
    
            
        else
        {
        
        var touchPoint = gestureRecognizer.locationInView(self.mapView)
            
        var newCoordinate: CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
        var myAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = newCoordinate
      //  myAnnotation.title = "Hello"
        locationArray.append(myAnnotation)
        self.mapView.addGestureRecognizer(gestureRecognizer)
        refreshAnnotations()
        }
    }
    func refreshAnnotations(){
        mapView.addAnnotations(locationArray)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshAnnotations()
        var longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "action:")
        mapView.addGestureRecognizer(longPressRecognizer)
    }
    
    
    //A function for creating a label programatically.
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
    
    
    

    
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
   //     println("View for annotation on.")
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
       // println("Does this work?")

        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.centerOffset = CGPoint(x: 0.0, y: 200.0)
//            pinView!.animatesDrop = true
//            pinView!.pinColor = .Green
//            pinView!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
   
 
    
    
    
    
    
 

    func mapView(mapView: MKMapView!, didDeselectAnnotationView view: MKAnnotationView!) {
        
        println("annotation selected")
        
        if deleteOn == true {
         //   println("View to be deleted: \(view)")
          //  println("Array from which to remove items: \(locationArray)")
            
            println("delete is on")
            
          var arrayCounter = 0
           for arrayAnnotation in locationArray{
            println(arrayAnnotation.coordinate.latitude)
            if view.annotation.coordinate.latitude == arrayAnnotation.coordinate.latitude && view.annotation.coordinate.longitude == arrayAnnotation.coordinate.longitude {
//                println("Before removal: \(locationArray)")

                locationArray.removeAtIndex(arrayCounter)
                mapView.removeAnnotation(arrayAnnotation)

//                println("After removal: \(locationArray)")
                println("match!")
                return
            }
            arrayCounter++
            }
        }
            
     else  {
            
            println("delete is off")

            
        let flickrViewController = self.storyboard!.instantiateViewControllerWithIdentifier("FlickrCollectionViewController") as! FlickrCollectionViewController
        var chosenLatitude: Double = view.annotation.coordinate.latitude
        var chosenLongitude: Double = view.annotation.coordinate.longitude
        mapView.deselectAnnotation(view.annotation, animated: true)

        flickrViewController.transferredLatitude = chosenLatitude
        flickrViewController.transferredLongitude = chosenLongitude
      //  self.presentViewController(flickrViewController, animated: true, completion: nil)
        self.navigationController!.pushViewController(flickrViewController, animated: true)
        }


    }

}



