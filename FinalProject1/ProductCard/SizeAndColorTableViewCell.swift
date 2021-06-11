//
//  SizeAndColorTableViewCell.swift
//  FinalProject1
//
//  Created by Vladimir Karsakov on 20.04.2021.
//

import UIKit

class SizeAndColorTableViewCell: UITableViewCell {
    
    lazy var backView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 70))
        return view
    }()
    
    lazy var colorLabel: UILabel = {
        let colorLabel = UILabel(frame: CGRect(x: 10, y: 15, width: 170, height: 40))
        return colorLabel
    }()
    
    lazy var imageCheck: UIImageView = {
        let imageCheck = UIImageView(frame: CGRect(x: 190, y: 25, width: 20, height: 20))
        return imageCheck
    }()
    
    lazy var sizeLabel: UILabel = {
        let sizeLabel = UILabel(frame: CGRect(x: 220, y: 15, width: 150, height: 40))
        return sizeLabel
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addSubview(backView)
        backView.addSubview(colorLabel)
        backView.addSubview(imageCheck)
        backView.addSubview(sizeLabel)
        // Configure the view for the selected state
    }
}
