//
//  HeaderView.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 20/05/2026.
//

import UIKit

class HeaderView: UICollectionReusableView {

    @IBOutlet private weak var headerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headerLabel.font = UIFont(name: "Nunito-Bold", size: 24)
    }
    
    func cofig(header: String){
        headerLabel.text = header
    }
}
