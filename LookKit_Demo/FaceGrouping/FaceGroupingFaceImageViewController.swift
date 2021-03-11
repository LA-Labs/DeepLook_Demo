//
//  FaceGroupingFaceImageViewController.swift
//  LookKit_Demo
//
//  Created by Amir Lahav on 05/03/2021.
//

import UIKit
import LookKit

class FaceGroupingFaceImageViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
    var imageID: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global().async {
            let image = ImageFetcherService().image(from: self.imageID)
            DispatchQueue.main.async {
                self.userImageView.image = image
            }
        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
