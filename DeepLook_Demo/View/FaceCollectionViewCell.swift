//
//  FaceCollectionViewCell.swift
//  FaceAI_Example
//
//  Created by Amir Lahav on 21/02/2021.
//

import UIKit

class FaceCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var faceImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        faceImageView.layer.masksToBounds = true
        #if targetEnvironment(macCatalyst)
        title.font = UIFont.systemFont(ofSize: 18)
        #endif
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        faceImageView.image = nil
        title.text = ""
    }
}
