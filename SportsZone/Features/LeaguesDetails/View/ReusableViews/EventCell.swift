//
//  EventCell.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 20/05/2026.
//

import UIKit

class EventCell: UICollectionViewCell {

    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var team2Image: UIImageView!
    @IBOutlet private weak var team1Image: UIImageView!
    @IBOutlet private weak var team2Label: UILabel!
    @IBOutlet private weak var team1Label: UILabel!
    @IBOutlet private weak var tittleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tittleLabel.font = UIFont(name: "Nunito-SemiBold", size: 14)
        team1Label.font = UIFont(name: "Nunito-Bold", size: 16)
        team2Label.font = UIFont(name: "Nunito-Bold", size: 16)
        scoreLabel.font = UIFont(name: "Nunito-Bold", size: 16)
        timeLabel.font = UIFont(name: "Nunito-Regular", size: 14)
        
        team1Image.layer.cornerRadius = team1Image.frame.width / 2
        team1Image.clipsToBounds = true
        
        team2Image.layer.cornerRadius = team2Image.frame.width / 2
        team2Image.clipsToBounds = true
        
    }

    func config(event: EventModel){
        tittleLabel.text = event.eventName
        team1Label.text = event.team1?.name
        team2Label.text = event.team2?.name
        scoreLabel.text = event.score
        timeLabel.text = event.time
        
        //TODO:: config teams imges
    }
}
