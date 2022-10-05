//  Copyright © 2019 la-labs. All rights reserved.

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
