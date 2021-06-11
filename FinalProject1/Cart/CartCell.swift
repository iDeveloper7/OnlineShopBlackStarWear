//
//  CartCellTableViewCell.swift
//  FinalProject1
//
//  Created by Vladimir Karsakov on 17.05.2021.
//

import UIKit

protocol DeleteCellDelegate: NSObjectProtocol {
    func deleteCellPressed(_ cartCell: CartCell, indexPath: IndexPath)
}

class CartCell: UITableViewCell {
    
    @IBOutlet weak var imageMain: CustomImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var deleteButtobOutlet: UIButton!
    
    var delegate: DeleteCellDelegate?
    var indexPath: IndexPath?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func deleteCellAction(_ sender: UIButton) {
        if let delegate = delegate, let indexPath = indexPath{
            delegate.deleteCellPressed(self, indexPath: indexPath)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
