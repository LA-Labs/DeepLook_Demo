//
//  Crop_faces.swift
//  LookKit_Demo
//
//  Created by Amir Lahav on 06/04/2021.
//

import UIKit
import LookKit

func cropFaces() {
    
    let image = UIImage(named: "angelina")!
    
    // normlized bounding box.
    let faceLocations = DeepLook.faceLocation(image)
    
    // Crop chip faces.
    let cropFaces = DeepLook.cropFaces(image,
                                       locations: faceLocations)
}
