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
        compare()
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
        let face1 = UIImage(named: "face1")
        let face2 = UIImage(named: "face2")
        
        face1ImageView.image = face1
        face2ImageView.image = face2
    
        title = "Face Recognition"
        
        compare()
    }
    
    func compare() {
            
        let processConfig = ProcessConfiguration()
        processConfig.faceChipPadding = 0.4
        processConfig.landmarksAlignmentAlgorithm = .pointsDlib5
        processConfig.faceEncoderModel = .facenet
        
        // Compare
        Recognition.verify(sourceImage: face1ImageView.image!,
                           targetImages: face2ImageView.image!,
                           similarityThreshold: 0.75,
                           processConfiguration: processConfig) {[weak self] (result) in
            switch result {
            case .success(let result):
                print(result.count)
                self?.verifiedFacesVC?.faces.removeAll()
                result.forEach { (match) in
                    self?.verifiedFacesVC?.faces.append(match.sourceFace)
                    self?.verifiedFacesVC?.faces.append(match.targetFace)
                    print(match.distance)
                }
                if result.isEmpty {
                    self?.alertEmptyResults()
                }
                self?.verifiedFacesVC?.collectionView.reloadData()
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
