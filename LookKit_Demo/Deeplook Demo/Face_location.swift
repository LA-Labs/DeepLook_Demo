//
//  Face_location.swift
//  LookKit_Demo
//
//  Created by Amir Lahav on 06/04/2021.
//

import UIKit
import LookKit
import Vision

func findFaceLocations() {
    
    let image = UIImage(named: "angelina")!
    
    // move to background thread
    DispatchQueue.global().async {
        
        // get all normalized bounding boxes.
        let faceLocations = DeepLook.faceLocation(image)
        
        // bounding box location with respective to image size.
        let boundingBoxes = faceLocations.map { (faceLocations) -> CGRect in
            VNImageRectForNormalizedRect(faceLocations,
                                         Int(image.cgImage!.width),
                                         Int(image.cgImage!.height))
        }
        
    }

}
