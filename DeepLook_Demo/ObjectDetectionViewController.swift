//
//  ObjectDetectionViewController.swift
//  LookKit_Demo
//
//  Created by Amir Lahav on 24/02/2021.
//

import UIKit
import DeepLook

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
    Task {
      await detect(image: image!)
    }

    title = "Object Detecting"
  }

  func detect(image: UIImage) async {

    // Create new action for the detector.
    // In this case object detection.
    // Can be piped to other actions like object location, face location, etc.
    do {
      let action: ActionType = .objectDetecting
      let photos = try await Detector.analyze(action, sourceImage: image)
      self.detectingObject.text = photos.first?.tags.reduce("", { (result, object) -> String in
        if !result.isEmpty {
          return result + ", " + object.identifier
        }else {
          return object.identifier
        }
      })
    } catch {
      
    }
  }
}

extension ObjectDetectionViewController: UIImagePickerControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])  {
        if let tempImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
          Task {
            await detect(image: tempImage)
            detectableImage.image = tempImage
          }
        }
        
        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
