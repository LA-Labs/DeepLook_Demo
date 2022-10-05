//  Copyright © 2019 la-labs. All rights reserved.

import UIKit
import DeepLook

func cropFaces() async {

  let image = UIImage(named: "angelina")!

  // normalized bounding box.
  let faceLocations = DeepLook.faceLocation(image)

  // Crop chip faces.
  let cropFaces = DeepLook.cropFaces(image,
                                     locations: faceLocations)
}
