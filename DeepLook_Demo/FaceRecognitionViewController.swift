//  Copyright © 2019 la-labs. All rights reserved.

import UIKit
import DeepLook

class FaceRecognitionViewController: UIViewController, UINavigationControllerDelegate {

  // Outlets
  @IBOutlet weak var indicator: UIActivityIndicatorView! {
    didSet {
      indicator.isHidden = true
    }
  }
  @IBOutlet weak var face1ImageView: UIImageView!
  @IBOutlet weak var face2ImageView: UIImageView!
  @IBOutlet weak var faceMatchWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var inputFacesCollectionView: UICollectionView!

  // Actions
  @IBAction func photoADidTap(_ sender: UIButton) {
    pictureADidPick = true
    presentPhotoPicker()
  }

  @IBAction func photoBDidTap(_ sender: UIButton) {
    pictureADidPick = false
    presentPhotoPicker()
  }

  @IBAction func verifyDidTap(_ sender: UIButton) {
    Task {
      indicator.startAnimating()
      indicator.isHidden = false
      await compare()
    }
  }


  var verifiedFacesVC: FaceGroupingDetailViewController?
  var pictureADidPick: Bool = true
  var inputFaces: [Face] = []


  override func viewDidLoad() {
    super.viewDidLoad()

    let width = (UIScreen.main.bounds.width-4)/4
#if targetEnvironment(macCatalyst)
    faceMatchWidthConstraint.constant =  199 * 2 + 1
#else
    faceMatchWidthConstraint.constant = width * 2 + 1
#endif
    view.layoutIfNeeded()


    // Load 2 demo images
    let left = UIImage(named: "brangelina1")
    let right = UIImage(named: "brangelina2")

    face1ImageView.image = left
    face2ImageView.image = right
    
    title = "Face Recognition"

  }

  func compare() async {

    // Verify configuration
    let processConfig = ProcessConfiguration()

    // Use Sphere Face 5 point landmarks to align face
    processConfig.landmarksAlignmentAlgorithm = .pointsSphereFace5

    // Use facenet to encode face to 128 vector representation.
    processConfig.faceEncoderModel = .facenet

    // Verify faces from image A in image B
    // Result contains all match faces from image A found on image B
    let result =
    try! await Recognition.verify(sourceImage: face1ImageView.image!,
                                  targetImages: face2ImageView.image!,
                                  // maximum threshold
                                  similarityThreshold: 0.8,
                                  processConfiguration: processConfig)
    // Remove all faces
    self.verifiedFacesVC?.faces.removeAll()
    result.forEach { (match) in

      // Append match faces.
      self.verifiedFacesVC?.faces.append(match.sourceFace)
      self.verifiedFacesVC?.faces.append(match.targetFace)
      print(match.distance)
    }
    if result.isEmpty {
      self.alertEmptyResults()
    }
    indicator.stopAnimating()
    indicator.isHidden = true
    self.verifiedFacesVC?.collectionView.reloadData()
  }

  func presentPhotoPicker() {
    let imagePickerController = UIImagePickerController()
    imagePickerController.allowsEditing = false
    imagePickerController.sourceType = .photoLibrary
    imagePickerController.delegate = self
    present(imagePickerController, animated: true, completion: nil)
  }

  func alertEmptyResults() {
    let alertController = UIAlertController(title: "No Match found", message: "Try different photos or change similarity threshold", preferredStyle: .alert)

    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    // get a reference to the embedded PageViewController on load
    if let vc = segue.destination as? FaceGroupingDetailViewController,
       segue.identifier == "loadInputFaces" {
      verifiedFacesVC = vc
      verifiedFacesVC?.canSelect = false
    }
  }
}


extension FaceRecognitionViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let tempImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if pictureADidPick {
                face1ImageView.image = tempImage
            }else {
                face2ImageView.image = tempImage
            }
        }
        // Dismiss Picker
        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
