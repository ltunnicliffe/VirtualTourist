//
//  FlickrLogin.swift
//  Virtual Tourist
//
//  Created by Luke on 2015/07/29.
//  Copyright (c) 2015年 Luke Tunnicliffe. All rights reserved.
//

import Foundation
import UIKit

class FlickrLogin: NSObject {
    /* 1 - Define constants */
    let BASE_URL = "https://api.flickr.com/services/rest/"
    let METHOD_NAME = "flickr.photos.search"
    let API_KEY = "0fee5566b473a9b26e51874aca940b7b"
//    var LAT: Double = 37.76513627957266
//    var LON: Double = -122.42020770907402
    var LAT: Double!
    var LON: Double!
    let EXTRAS = "url_m"
    let DATA_FORMAT = "json"
    let NO_JSON_CALLBACK = "1"
    
    
    var photoImageView: UIImageView!
    var photoTitle: UILabel!
    
    
    
    func loginToFlickr(selectedLatitude:Double, selectedLongitude:Double){
        
        /* 2 - API method arguments */
        let methodArguments = [
            "method": METHOD_NAME,
            "api_key": API_KEY,
            "lat": selectedLatitude,
            "lon": selectedLongitude,
            "extras": EXTRAS,
            "format": DATA_FORMAT,
            "nojsoncallback": NO_JSON_CALLBACK
        ]
        getImageFromFlickrBySearch(methodArguments as! [String : AnyObject])
    }
    
    func getImageFromFlickrBySearch(methodArguments: [String : AnyObject]) {
        
        let session = NSURLSession.sharedSession()
        let urlString = BASE_URL + escapedParameters(methodArguments)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            if let error = downloadError {
                println("Could not complete the request \(error)")
            } else {
                
                var parsingError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                
                if let photosDictionary = parsedResult.valueForKey("photos") as? [String:AnyObject] {
                    
                    println(photosDictionary)
                    
                } else {
                    println("Cant find key 'photos' in \(parsedResult)")
                }
            }
        }
        
        task.resume()
    }


    
//        let session = NSURLSession.sharedSession()
//        let urlString = BASE_URL + escapedParameters(methodArguments as! [String : AnyObject])
//        let url = NSURL(string: urlString)!
//        let request = NSURLRequest(URL: url)
//        
//        /* 4 - Initialize task for getting data */
//        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
//            if let error = downloadError {
//                println("Could not complete the request \(error)")
//            } else {
//                /* 5 - Success! Parse the data */
//                var parsingError: NSError? = nil
//                let parsedResult: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)
//                
//                
//                if let photosDictionary = parsedResult.valueForKey("photos") as? NSDictionary {
//                    if let photoArray = photosDictionary.valueForKey("photo") as? [[String: AnyObject]] {
//                        
//                        /* 6 - Grab a single, random image */
//                        let randomPhotoIndex = Int(arc4random_uniform(UInt32(photoArray.count)))
//                        let photoDictionary = photoArray[randomPhotoIndex] as [String: AnyObject]
//                        
//                        /* 7 - Get the image url and title */
//                        let photoTitle = photoDictionary["title"] as? String
//                        let imageUrlString = photoDictionary["url_m"] as? String
//                        let imageURL = NSURL(string: imageUrlString!)
//                        
//                        /* 8 - If an image exists at the url, set the image and title */
//                        if let imageData = NSData(contentsOfURL: imageURL!) {
//                            dispatch_async(dispatch_get_main_queue(), {
//                                self.photoImageView.image = UIImage(data: imageData)
//                                self.photoTitle.text = photoTitle
//                            })
//                        } else {
//                            println("Image does not exist at \(imageURL)")
//                        }
//                    } else {
//                        println("Cant find key 'photo' in \(photosDictionary)")
//                    }
//                } else {
//                    println("Cant find key 'photos' in \(parsedResult)")
//                }
//            }
//        }
//        
//        /* 9 - Resume (execute) the task */
//        task.resume()
//        
//        
//        
//        
//    }
//    
    func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + join("&", urlVars)
    }

    
    // Shared Instance
    class func sharedInstance() -> FlickrLogin {
        struct Singleton {
            static var sharedInstance = FlickrLogin()
        }
        return Singleton.sharedInstance
    }
    
    
    
}

