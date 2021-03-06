//
//  FlickrLogin.swift
//  Virtual Tourist
//
//  Created by Luke on 2015/07/29.
//  Copyright (c) 2015年 Luke Tunnicliffe. All rights reserved.
//

import Foundation
import UIKit


var photosArray = [String]()


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
        
        print(methodArguments["lat"])
        print(methodArguments["lon"])
        photosArray = []
        print("\(photosArray)")
        
        let session = NSURLSession.sharedSession()
        let urlString = BASE_URL + escapedParameters(methodArguments)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            if let error = downloadError {
               print("Could not complete the request \(error)")
            } else {
//                var parsingError: NSError? = nil
                let parsedResult = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                if let photosDictionary = parsedResult.valueForKey("photos") as? NSDictionary {
                    if let photoDictionary = photosDictionary.valueForKey("photo") as? NSArray {
                    for photo in photoDictionary{
                        if let photoURL: String = photo["url_m"] as? String{
                            photosArray.append(photoURL)
                        }
                        else {
                            print("No url_m" )
                        }
                    }
                    }else {
                            print("Cant find key 'photo' in \(photosDictionary)")
                        }
                    } else {
                         print("Cant find key 'photo' in \(parsedResult)")
                    }
              }
            }
        task.resume()
    }

 
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
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }

    
    // Shared Instance
    class func sharedInstance() -> FlickrLogin {
        struct Singleton {
            static var sharedInstance = FlickrLogin()
        }
        return Singleton.sharedInstance
    }
    
    
    
}

