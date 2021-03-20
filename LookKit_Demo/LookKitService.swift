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
        let options = AssetFetchingOptions(sortDescriptors: nil,
                                           assetCollection: .allAssets,
                                           fetchLimit: 100)
        
        // Cluster Options
        let culsterOptions = ClusterOptions(minimumClusterSize: 2,
                                            numberIterations: 100,
                                            faceSimilarityThreshold: 0.75)
        
        let processConfiguration = ProcessConfiguration()
        processConfiguration.minimumQualityFilter = .medium
        processConfiguration.landmarksAlignmentAlgorithm = .pointsSphereFace5
        processConfiguration.faceChipPadding = 0.0
        
        // Start Clustering
        Recognition.cluster(fetchOptions: options,
                            culsterOptions: culsterOptions,
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
