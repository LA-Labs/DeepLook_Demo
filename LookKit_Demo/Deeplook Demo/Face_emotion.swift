//
//  Face_emotion.swift
//  LookKit_Demo
//
//  Created by Amir Lahav on 06/04/2021.
//

import UIKit
import LookKit

func facesEmotion() {
    
    let image = UIImage(named: "angelina")!
    
    // move to background thread
    DispatchQueue.global().async {
        
        // get face emotion for each face.
        let faceLocations = DeepLook.faceEmotion(image)
        
    }
    
}
