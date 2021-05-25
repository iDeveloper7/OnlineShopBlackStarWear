//
//  CartCellTableViewCell.swift
//  FinalProject1
//
//  Created by Vladimir Karsakov on 17.05.2021.
//

import UIKit

class CartCell: UITableViewCell {
    
    @IBOutlet weak var imageMain: CustomImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
