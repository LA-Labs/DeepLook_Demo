//
//  FaceGroupingDetailViewController.swift
//  LookKit_Demo
//
//  Created by Amir Lahav on 03/03/2021.
//

import UIKit
import LookKit

class FaceGroupingDetailViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var faces: [Face] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Collection View
        collectionView.register(UINib(nibName: "FaceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width-4)/4
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1

        collectionView.collectionViewLayout = layout
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
        // Do any additional setup after loading the view.
    }

}

//MARK: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout
extension FaceGroupingDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        faces.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? FaceCollectionViewCell else {
            fatalError()
        }
        DispatchQueue.main.async {
            cell.faceImageView.image = self.faces[indexPath.row].faceCroppedImage
        }

        return cell
    }
}
