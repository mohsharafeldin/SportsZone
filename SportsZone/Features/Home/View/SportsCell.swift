//
//  SportsCell.swift
//  SportsZone
//
//  Created by mohamed sharaf on 20/05/2026.
//

import UIKit

class SportsCell: UICollectionViewCell {
   
    
    @IBOutlet weak var sportImage: UIImageView!
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var sportName: UILabel!
    
    
    
    
    override func awakeFromNib() {
            super.awakeFromNib()
            
        sportImage.layer.cornerRadius = 30
        backView.alpha = 0.3
        backView.layer.cornerRadius = 30
        backView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            
            //sportImage.clipsToBounds = true
            
        }
    
}
