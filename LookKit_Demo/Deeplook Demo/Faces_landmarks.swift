//
//  Faces_landmarks.swift
//  LookKit_Demo
//
//  Created by Amir Lahav on 06/04/2021.
//

import UIKit
import LookKit

func findFacesLandmakrs(completion: @escaping (Result<[[CGPoint]],Error>) -> Void) {
    
    let image = UIImage(named: "angelina")!
    
    DispatchQueue.global().async {
        
        // list of face landmarks.
        let faceLandmarks = DeepLook.faceLandmarks(image)
        
        // get image size
        let imageSize =  CGSize(width: image.cgImage!.width, height: image.cgImage!.height)
        
        // convert to UIKit coordinate system.
        let points = faceLandmarks.map({ (landmarks) -> [CGPoint] in
            landmarks.pointsInImage(imageSize: imageSize)
                .map({ (point) -> CGPoint in
                    CGPoint(x: point.x, y: imageSize.height - point.y)
                })
        })
        
        completion(.success(points))
        
    }

}
