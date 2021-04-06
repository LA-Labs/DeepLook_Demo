//
//  Find_faces_landmarks.swift
//  LookKit_Demo
//
//  Created by Amir Lahav on 06/04/2021.
//

import UIKit
import LookKit

func findFacesLandmakrs() {
    
    let image = UIImage(named: "angelina")!
    
    // list of face landmarks.
    let faceLandmarks = DeepLook.faceLandmarks(image)
}
