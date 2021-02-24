//
//  ViewController.swift
//  LookKit_Demo_Local
//
//  Created by Amir Lahav on 23/02/2021.
//

import UIKit
import Combine
import LookKit

class FaceGroupingViewController: UIViewController {

    // Outlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Service
    let service = LookKitService()
    
    // Combine
    var binding = Set<AnyCancellable>()
    
    // Objects
    var faces: [[Face]] = [] {
        didSet { collectionView.reloadData() }
    }
    
    deinit {
        print("deinit \(self)")
    }
    
    // Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Face Grouping Demo"
        
        // Collection View
        collectionView.register(UINib(nibName: "FaceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.register(UINib(nibName: "HeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        // Chack user photos authorization using PhotosAuthorizationService.
        PhotosAuthorizationService.checkPhotoLibraryPermission { [weak self]  (result) in
            switch result {
            case .success():
                // If we have, or the user just grant permission
                // Start clustering faces.
                self?.service.startClustering()
            case .failure(let error):
                print(error)
            }
        }
        service.faces.sink {(result) in
            
        } receiveValue: { [weak self]  (faces) in
            // Clustering service just finished and update us with the new faces collection.
            self?.faces = faces
        }.store(in: &binding)
    }
}

//MARK: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout
extension FaceGroupingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        faces.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        faces.isEmpty ? 0 : faces[section].count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? FaceCollectionViewCell else {
            fatalError()
        }
        DispatchQueue.main.async {
            cell.faceImageView.image = self.faces[indexPath.section][indexPath.row].faceCroppedImage
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as? HeaderCollectionReusableView else {
            fatalError()
        }

        headerView.frame.size.height = 48
        headerView.title.text = "Cluster ID: \(indexPath.section)"
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 48)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width-3)/4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        1.0
    }

}
