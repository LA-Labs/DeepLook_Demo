//  Copyright © 2019 la-labs. All rights reserved.

import Foundation
import DeepLook
import Combine

class DeepLookService {
  var faces: PassthroughSubject<[[Face]], Error> = .init()

  func startClustering() async throws {
    // Fetch Options
    // Last 200 images from the user gallery
    let options = AssetFetchingOptions(sortDescriptors: nil,
                                       assetCollection: .allPhotos,
                                       fetchLimit: 200)

    // Cluster Options
    let clusterOptions = ClusterOptions(minimumClusterSize: 2,
                                        numberIterations: 200,
                                        // Maximum l2 norm euclidean distance between 2 faces
                                        faceSimilarityThreshold: 0.8)

    let processConfiguration = ProcessConfiguration()
    processConfiguration.minimumQualityFilter = .low
    processConfiguration.landmarksAlignmentAlgorithm = .pointsSphereFace5
    processConfiguration.minimumFaceArea = 6000
    processConfiguration.fetchImageSize = 800


    // Start Clustering
    let result = try await Recognition.cluster(fetchOptions: options,
                                               clusterOptions: clusterOptions,
                                               processConfiguration: processConfiguration)
    let faces = result.sorted { (a, b) -> Bool in

      // Sort by cluster size
      a.count > b.count
    }.map { (faces) -> [Face] in
      var faces = faces

      // Sort by face quality
      faces.sort { (a, b) -> Bool in
        a.quality > b.quality
      }
      return faces
    }
    self.faces.send(faces)
  }
}
