//
//  FaceCollectionViewCell.swift
//  FaceAI_Example
//
//  Created by Amir Lahav on 21/02/2021.
//

import UIKit

class FaceCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var faceCount: UILabel!
    @IBOutlet weak var faceImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        faceImageView.image = nil
        faceCount.text = ""
    }
}
