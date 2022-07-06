//
//  Crop_faces.swift
//  LookKit_Demo
//
//  Created by Amir Lahav on 06/04/2021.
//

import UIKit
import DeepLook

func cropFaces() async {

  let image = UIImage(named: "angelina")!

  // normalized bounding box.
  let faceLocations = await DeepLook.faceLocation(image)

  // Crop chip faces.
  let cropFaces = DeepLook.cropFaces(image,
                                     locations: faceLocations)
}
