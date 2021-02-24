//
//  FaceRecognitionViewController.swift
//  LookKit_Demo
//
//  Created by Amir Lahav on 24/02/2021.
//

import UIKit
import LookKit
class FaceRecognitionViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var face1ImageView: UIImageView!
    @IBOutlet weak var face2ImageView: UIImageView!
    @IBOutlet weak var matchLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load 2 demo images
        let face1 = UIImage(named: "face1")!
        let face2 = UIImage(named: "face2")!
        
        face1ImageView.image = face1
        face2ImageView.image = face2
        
        // Compare
        Vision.compareFaces(sourceImage: face1,
                            targetImage: face2,
                            similarityThreshold: 0.7,
                            qualityFilter: .medium) { (result) in
            switch result {
            case .success((let result, _)):
                self.matchLabel.text = result ? "Match" : "Not Match"
                self.matchLabel.textColor = result ? .systemGreen : .systemRed
            case .failure(let error):
                print(error)
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
