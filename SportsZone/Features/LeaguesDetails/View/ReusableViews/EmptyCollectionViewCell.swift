//
//  EmptyCollectionViewCell.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 01/06/2026.
//

import UIKit

class EmptyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var messageLale: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupShadow()
        messageLale.font = UIFont(name: "Nunito-SemiBold", size: 16)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath =
            UIBezierPath(
                roundedRect: bounds,
                cornerRadius: 25
            ).cgPath
    }
    
    func config(_ massage: String) {
        messageLale.text = massage
    }
    
    private func setupShadow() {
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 6
        layer.masksToBounds = false
    }
}
