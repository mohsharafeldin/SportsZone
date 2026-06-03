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
        
        messageLale.font = UIFont(name: "Nunito-SemiBold", size: 16)
    }

    func config(_ massage: String) {
        messageLale.text = massage
    }
}
