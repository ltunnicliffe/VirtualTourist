//
//  FlickrCollectionViewController.swift
//  Virtual Tourist
//
//  Created by Luke on 2015/07/29.
//  Copyright (c) 2015年 Luke Tunnicliffe. All rights reserved.
//

import UIKit
import CoreData
import MapKit

//class FlickrCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,NSFetchedResultsControllerDelegate {

    class FlickrCollectionViewController: UIViewController{

    @IBOutlet var mapView2: MKMapView!
        
        var transferredLatitude:Double!
        var transferredLongitude:Double!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        FlickrLogin.sharedInstance().loginToFlickr(transferredLatitude, selectedLongitude: transferredLongitude)


        // Do any additional setup after loading the view.
    }
    @IBAction func newCollectionButton(sender: AnyObject) {
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
        

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
