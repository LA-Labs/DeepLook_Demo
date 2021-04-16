//
//  FaceGroupingFaceImageViewController.swift
//  LookKit_Demo
//
//  Created by Amir Lahav on 05/03/2021.
//

import UIKit
import DeepLook

class FaceGroupingFaceImageViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
    var imageID: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global().async {
            let image = ImageFetcherService(options: ImageFetcherOptions())
                .image(from: self.imageID)
            DispatchQueue.main.async {
                self.userImageView.image = image
            }
        }
    }
}
