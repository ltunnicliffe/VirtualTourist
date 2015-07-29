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
        myAnnotation.title = "Hello"
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
        println("Does this work?")

        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.centerOffset = CGPoint(x: 0.0, y: -200.0)
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
        let flickrViewController = self.storyboard!.instantiateViewControllerWithIdentifier("FlickrCollectionViewController") as! FlickrCollectionViewController
        var chosenLatitude: Double = view.annotation.coordinate.latitude
        var chosenLongitude: Double = view.annotation.coordinate.longitude
        flickrViewController.transferredLatitude = chosenLatitude
        flickrViewController.transferredLongitude = chosenLongitude
        self.presentViewController(flickrViewController, animated: true, completion: nil)

    }
//    
//    - (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
//    {
//    [mapView deselectAnnotation:view.annotation animated:YES];
//    
//    DetailsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsPopover"];
//    controller.annotation = view.annotation;
//    self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
//    self.popover.delegate = self;
//    [self.popover presentPopoverFromRect:view.frame
//    inView:view.superview
//    permittedArrowDirections:UIPopoverArrowDirectionAny
//    animated:YES];
//    }
    
    
//    
//    
//    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        println("Pressed")
//        if control == annotationView.rightCalloutAccessoryView {
//            let flickrViewController = self.storyboard!.instantiateViewControllerWithIdentifier("FlickrCollectionViewController") as! FlickrCollectionViewController
//            self.presentViewController(flickrViewController, animated: true, completion: nil)
//        }
//    }
//    
    
    
    
}
