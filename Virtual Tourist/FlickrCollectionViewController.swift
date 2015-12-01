//
//  FlickrCollectionViewController.swift
//  Virtual Tourist
//
//  Created by Luke on 2015/07/29.
//  Copyright (c) 2015年 Luke Tunnicliffe. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class FlickrCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
  //  class FlickrCollectionViewController: UIViewController{
   @IBOutlet weak var collectionView: UICollectionView!


    @IBOutlet var mapView2: MKMapView!
        
        var transferredLatitude:Double!
        var transferredLongitude:Double!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.3, 0.3)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(transferredLatitude, transferredLongitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake (location, span)
        mapView2.setRegion(region, animated:true)
//        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
       dispatch_async(dispatch_get_main_queue()) {
        FlickrLogin.sharedInstance().loginToFlickr(self.transferredLatitude, selectedLongitude: self.transferredLongitude)
        }
    }
    @IBAction func newCollectionButton(sender: AnyObject) {
        collectionView.reloadData()
        }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Lay out the collection view so that cells take up 1/3 of the width,
        // with no space in between.
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let width = floor(self.collectionView.frame.size.width/3)
        layout.itemSize = CGSize(width: width, height: width)
        collectionView.collectionViewLayout = layout
    }
        
        func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
            return 1
        }
        
        func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return photosArray.count
        }
        
        func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
        
            let chosenString = photosArray[indexPath.row]
            let url = NSURL(string: chosenString)
            let urlRequest = NSURLRequest(URL: url!)
            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
                if error != nil {
                print(error)
                }
                else{
                if let imageVariable = UIImage(data: data!) {
                cell.flickrImage.image =  imageVariable
                }
                }
            }
            return cell
        }
    
}
