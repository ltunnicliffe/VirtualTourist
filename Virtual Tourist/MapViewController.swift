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

    var locationArray = [MKPointAnnotation]()
    
    
    
    @IBAction func deleteButton(sender: AnyObject) {
    }

    func action (gestureRecognizer: UIGestureRecognizer) {
        
//        if (gestureRecognizer.state == UIGestureRecognizerState.Ended)
//        {
//            self.mapView.removeGestureRecognizer(gestureRecognizer)
//        }
        
        
        
        if (gestureRecognizer.state == UIGestureRecognizerState.Ended) || (gestureRecognizer.state == UIGestureRecognizerState.Changed){
        
        return
    }
    
            
        else
        {
        
        var touchPoint = gestureRecognizer.locationInView(self.mapView)
        var newCoordinate: CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
        var myAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = newCoordinate
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
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        println("View for annotation on.")
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            pinView!.pinColor = .Purple
            pinView!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    
    
    
    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        println("Pressed")
        if control == annotationView.rightCalloutAccessoryView {
            let flickrViewController = self.storyboard!.instantiateViewControllerWithIdentifier("FlickrCollectionViewController") as! FlickrCollectionViewController
            self.presentViewController(flickrViewController, animated: true, completion: nil)
        }
    }
    
    
    
    
}
