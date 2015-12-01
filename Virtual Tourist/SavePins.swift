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

extension MapViewController {
    
    
    func saveLocation(annotation:MKPointAnnotation) {
        
        locationArray.append(annotation)

        for annotation in locationArray {
            
            
            
            
            print(annotation.coordinate.latitude)
            print(annotation.description)
        }
    }
    
    
    
    
    
    
}
