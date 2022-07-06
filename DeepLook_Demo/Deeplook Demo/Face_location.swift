//
//  Face_location.swift
//  LookKit_Demo
//
//  Created by Amir Lahav on 06/04/2021.
//

import UIKit
import DeepLook
import Vision

func findFaceLocations() async {

  let image = UIImage(named: "angelina")!
  // get all normalized bounding boxes.
  let faceLocations = await DeepLook.faceLocation(image)

  // bounding box location with respective to image size.
  let boundingBoxes = faceLocations.map { (faceLocations) -> CGRect in
    VNImageRectForNormalizedRect(faceLocations,
                                 Int(image.cgImage!.width),
                                 Int(image.cgImage!.height))

  }
}
