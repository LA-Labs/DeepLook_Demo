//  Copyright © 2019 la-labs. All rights reserved.

import UIKit
import DeepLook

func facesEmotion() async {

  let image = UIImage(named: "angelina")!
  
  // Get face emotion for each face.
  let faceEmotions = DeepLook.faceEmotion(image)
}
