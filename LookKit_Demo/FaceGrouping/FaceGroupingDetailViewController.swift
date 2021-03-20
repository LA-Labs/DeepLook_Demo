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
    var canSelect: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Collection View
        collectionView.register(UINib(nibName: "FaceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width-4)/4
        #if targetEnvironment(macCatalyst)
        layout.itemSize = CGSize(width: 199, height: 190 + 35)
        #else
        layout.itemSize = CGSize(width: width, height: width + 25)
        #endif
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1

        collectionView.collectionViewLayout = layout
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedPath = collectionView.indexPathsForSelectedItems?.first else { return }
        if let target = segue.destination as? FaceGroupingFaceImageViewController {
            target.imageID = faces[selectedPath.row].localIdnetifier
        }
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
            cell.title.text = self.faces[indexPath.row].quality > 0.01 ?  String(format: "Quality: %.2f", self.faces[indexPath.row].quality) : ""
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if canSelect {
            performSegue(withIdentifier: "showImage", sender: nil)
        }
    }
}
