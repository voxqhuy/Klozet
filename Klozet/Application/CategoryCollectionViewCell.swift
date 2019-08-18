//
//  CategoryCollectionViewCell.swift
//  Klozet
//
//  Created by Huy Vo on 8/3/19.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

//        backgroundColor = UIColor.white
        addShadowOnCell()
        addCornerRadiusOnContentView()
    }
    
    private func addShadowOnCell() {
        backgroundColor = .clear // very important
        layer.masksToBounds = false
        layer.shadowOpacity = 0.14
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor
    }

    private func addCornerRadiusOnContentView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
    }
}
