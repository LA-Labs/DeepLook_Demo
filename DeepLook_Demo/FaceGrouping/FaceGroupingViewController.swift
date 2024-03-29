//  Copyright © 2019 la-labs. All rights reserved.

import UIKit
import Combine
import DeepLook

class FaceGroupingViewController: UIViewController {

  // Outlet
  @IBOutlet weak var indicator: UIActivityIndicatorView! {
    didSet {
      indicator.isHidden = true
      indicator.stopAnimating()
    }
  }
  @IBOutlet weak var progressLabel: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!

  // Service
  let service = DeepLookService()

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

    self.title = "Face Grouping"

    // Collection View
    collectionView.register(UINib(nibName: "FaceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    collectionView.dataSource = self
    collectionView.delegate = self
    let layout = UICollectionViewFlowLayout()

    let width = (UIScreen.main.bounds.width-64)/3
#if targetEnvironment(macCatalyst)
    layout.itemSize = CGSize(width: 195, height: 190 + 35)
#else
    layout.itemSize = CGSize(width: width, height: width + 25)
#endif

    layout.minimumLineSpacing = 1
    layout.minimumInteritemSpacing = 1


    collectionView.collectionViewLayout = layout
    collectionView.collectionViewLayout.invalidateLayout()

    // Check user photos authorization using PhotosAuthorizationService.
    PhotosAuthorizationService.checkPhotoLibraryPermission { [weak self]  (result) in
      switch result {
      case .success():
        // If we have, or the user just grant permission
        // Start clustering faces.
        Task { [self] in
          self?.indicator.isHidden = false
          self?.indicator.startAnimating()
          try! await self?.service.startClustering()
        }
      case .failure(let error):
        print(error)
      }
    }
    service.faces
      .receive(on: RunLoop.main)
      .sink { result in

      } receiveValue: { [weak self] faces in

        // Clustering service just finished and update with the new faces collection.
        self?.faces = faces
        self?.progressLabel.isHidden = true
        self?.indicator.isHidden = true
        self?.indicator.stopAnimating()
      }.store(in: &binding)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let selectedPath = collectionView.indexPathsForSelectedItems?.first else { return }
    if let target = segue.destination as? FaceGroupingDetailViewController {
      target.faces = faces[selectedPath.row]
    }
  }
}

//MARK: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout
extension FaceGroupingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

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
    cell.faceImageView.image = self.faces[indexPath.row][0].faceCroppedImage
    cell.title.text = "\(self.faces[indexPath.row].count) Faces"
    cell.faceImageView.layer.cornerRadius = 12

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

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.performSegue(withIdentifier: "selectFaces", sender: nil)
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
  }
}
