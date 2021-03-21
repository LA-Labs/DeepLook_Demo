//
//  ObjectDetectionViewController.swift
//  LookKit_Demo
//
//  Created by Amir Lahav on 24/02/2021.
//

import UIKit
import LookKit

class ObjectDetectionViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var detectableImage: UIImageView!
    @IBOutlet weak var pickPhotoBtn: UIButton! {
        didSet { pickPhotoBtn.layer.cornerRadius = 8.0
        }
    }
    
    @IBAction func pickPhotoDidTap(_ sender: UIButton) {
        presentPhotoPicker()
    }
    
    func presentPhotoPicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var detectingObject: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "cat")
        detect(image: image!)
        
        title = "Object Detecting"
    }
    
    func detect(image: UIImage) {
        
        // Creat new action for the detecotor.
        // In this case object detection.
        // Can be piped to other actions like object location, face location, etc.
        let action = Filter.objectDetecting
        Detector.analyze(action, sourceImage: image) { (result) in
            switch result {
            case .success(let photo):

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
    }

}

extension ObjectDetectionViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let tempImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            detect(image: tempImage)
            detectableImage.image = tempImage
        }
        
        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
