//  Copyright © 2019 la-labs. All rights reserved.

import UIKit
import DeepLook
import Vision

func findFaceLocations() {

  let image = UIImage(named: "angelina")!
  // get all normalized bounding boxes.
  let faceLocations = DeepLook.faceLocation(image)

  // bounding box location with respective to image size.
  let boundingBoxes = faceLocations.map { faceLocations in
    VNImageRectForNormalizedRect(faceLocations,
                                 Int(image.cgImage!.width),
                                 Int(image.cgImage!.height))

  }
}
