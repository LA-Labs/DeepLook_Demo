//
//  FaceRecognitionViewController.swift
//  LookKit_Demo
//
//  Created by Amir Lahav on 24/02/2021.
//

import UIKit
import LookKit
class FaceRecognitionViewController: UIViewController, UINavigationControllerDelegate {
    
    // Outlets
    @IBOutlet weak var face1ImageView: UIImageView!
    @IBOutlet weak var face2ImageView: UIImageView!
    @IBOutlet weak var matchLabel: UILabel!
    

    @IBAction func photoADidTap(_ sender: UIButton) {
        pictureADidPick = true
        presentPhotoPicker()
    }
    @IBAction func photoBDidTap(_ sender: UIButton) {
        pictureADidPick = false
        presentPhotoPicker()
    }
    
    var pictureADidPick: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load 2 demo images
        let face1 = UIImage(named: "face1")
        let face2 = UIImage(named: "face2")
        
        face1ImageView.image = face1
        face2ImageView.image = face2
        
        compare()

        title = "Face Recongnition"
    }
    
    func compare() {
        
        // Reset Label
        matchLabel.text = "Checking..."
        matchLabel.textColor = .black
        
        // Compare
        Recognition.compareFaces(sourceImage: face1ImageView.image!,
                                 targetImage: face2ImageView.image!,
                                 similarityThreshold: 0.8) { (result) in
            switch result {
            case .success((let result, let distance)):
                self.matchLabel.text = result ? "Match, \(String(format: "Dist: %.2f", distance))" :
                    "Not Match, \(String(format: "Dist: %.2f", distance))"
                self.matchLabel.textColor = result ? .systemGreen : .systemRed
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func presentPhotoPicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }

}


extension FaceRecognitionViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let tempImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if pictureADidPick {
                face1ImageView.image = tempImage
            }else {
                face2ImageView.image = tempImage
            }
            compare()
        }
        // Dismiss Picker
        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
