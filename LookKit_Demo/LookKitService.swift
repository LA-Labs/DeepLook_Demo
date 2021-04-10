//
//  FaceAIService.swift
//  FaceAI_Example
//
//  Created by Amir Lahav on 21/02/2021.
//

import Foundation
import LookKit
import Combine

class LookKitService {
    var faces: PassthroughSubject<[[Face]], Error> = .init()
    
    func startClustering() {
        // Fetch Options
        // Last 200 images from the user gallery
        let options = AssetFetchingOptions(sortDescriptors: nil,
                                           assetCollection: .allPhotos,
                                           fetchLimit: 200)
        
        // Cluster Options
        let clusterOptions = ClusterOptions(minimumClusterSize: 2,
                                            numberIterations: 200,
                                            // Maximum l2 norm euclidean distance between 2 faces
                                            faceSimilarityThreshold: 0.75)
        
        let processConfiguration = ProcessConfiguration()
        processConfiguration.minimumQualityFilter = .low
        processConfiguration.landmarksAlignmentAlgorithm = .pointsSphereFace5
        processConfiguration.faceChipPadding = 0.0
        processConfiguration.fetchImageSize = 800
        
        // Start Clustering
        Recognition.cluster(fetchOptions: options,
                            clusterOptions: clusterOptions,
                            processConfiguration: processConfiguration) { [weak self] (result) in
            switch result {
            case .success(let faces):
                let faces = faces.sorted { (a, b) -> Bool in
                    
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
                
                
                self?.faces.send(faces)
            case .failure(let error):
                self?.faces.send(completion: .failure(error))
            }
        }
    }
}
