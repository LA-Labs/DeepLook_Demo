//
//  Face_emotion.swift
//  LookKit_Demo
//
//  Created by Amir Lahav on 06/04/2021.
//

import UIKit
import DeepLook

func facesEmotion() async {

  let image = UIImage(named: "angelina")!
  
  // Get face emotion for each face.
  let faceEmotions = await DeepLook.faceEmotion(image)


}
