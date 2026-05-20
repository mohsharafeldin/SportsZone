//
//  TeamsCollectionViewCell.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 19/05/2026.
//

import UIKit

class TeamsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var teamImage: UIImageView!
    @IBOutlet weak var teamName: UILabel!
    
    override func layoutSubviews() {
        teamImage.layer.cornerRadius = teamImage.frame.width / 2
        teamImage.clipsToBounds = true
        
        teamName.font = UIFont(name: "Nunito-SemiBold", size: 18)
    }
    
    func config(team: TeamModel){
        teamName.text = team.name
        
        //TODO: config team imge
    }
}
