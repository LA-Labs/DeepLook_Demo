//
//  ObjectDetectionViewController.swift
//  LookKit_Demo
//
//  Created by Amir Lahav on 24/02/2021.
//

import UIKit
import LookKit

class ObjectDetectionViewController: UIViewController {

    @IBOutlet weak var detectingObject: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "cat")
        Detector.detect(VFilter.objectDetecting(), sourceImage: image!) { (result) in
            switch result {
            case .success(let photo):
                print(photo)
                self.detectingObject.text = photo.first?.tags.reduce("", { (result, object) -> String in
                    if !result.isEmpty {
                        return result + ", " + object.identifier
                    }else {
                        return object.identifier
                    }
                })
            case .failure(_):
                break
            }
        }
        // Do any additional setup after loading the view.
    }

}
