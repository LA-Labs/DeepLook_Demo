//
//  Face_location_demo.swift
//  LookKit_Demo
//
//  Created by Amir Lahav on 06/04/2021.
//

import UIKit
import LookKit
import Vision

func findFaceLocations() {
    
    let image = UIImage(named: "angelina")!
    
    // normlized bounding box.
    let faceLocations = DeepLook.faceLocation(image)[0]
    
    // absolute bounding box in respective to image size.
    let boundingBox = VNImageRectForNormalizedRect(faceLocations,
                                                     Int(image.cgImage!.width),
                                                     Int(image.cgImage!.height))
}
