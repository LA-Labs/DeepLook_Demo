//
//  HeaderCollectionReusableView.swift
//  FaceAI_Example
//
//  Created by Amir Lahav on 21/02/2021.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = ""
    }
}
