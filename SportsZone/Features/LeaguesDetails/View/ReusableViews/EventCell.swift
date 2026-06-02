//
//  EventCell.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 20/05/2026.
//

import SDWebImage
import UIKit

class EventCell: UICollectionViewCell {
    
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var team2Image: UIImageView!
    @IBOutlet private weak var team1Image: UIImageView!
    @IBOutlet private weak var team2Label: UILabel!
    @IBOutlet private weak var team1Label: UILabel!
    @IBOutlet private weak var tittleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var eventView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tittleLabel.font = UIFont(name: "Nunito-SemiBold", size: 14)
        statusLabel.font = UIFont(name: "Nunito-SemiBold", size: 14)
        team1Label.font = UIFont(name: "Nunito-Bold", size: 16)
        team2Label.font = UIFont(name: "Nunito-Bold", size: 16)
        scoreLabel.font = UIFont(name: "Nunito-Bold", size: 16)
        timeLabel.font = UIFont(name: "Nunito-Regular", size: 14)
        dateLabel.font = UIFont(name: "Nunito-Regular", size: 14)
        
        team1Image.layer.cornerRadius = team1Image.frame.width / 2
        team1Image.clipsToBounds = true
        
        team2Image.layer.cornerRadius = team2Image.frame.width / 2
        team2Image.clipsToBounds = true
        
        self.setupShadow()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: 12
        ).cgPath
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
    
    func config(event: Event) {
        tittleLabel.text = event.leagueName
        statusLabel.text = event.eventStatus ?? ""
        team1Label.text = event.team1Name
        team2Label.text = event.team2Name
        scoreLabel.text =
        (event.eventFinalResult == nil || event.eventFinalResult == ""
         || event.eventFinalResult == "-")
        ? "VS"
        : event.eventFinalResult!
        timeLabel.text = event.leagueRound ?? ""
        dateLabel.text = "\(event.eventTime) | \(event.eventDate)"
        
        team1Image.sd_setImage(
            with: URL(string: event.team1Logo!),
            placeholderImage: UIImage(named: "logo.png")
        )
        
        team2Image.sd_setImage(
            with: URL(string: event.team2Logo!),
            placeholderImage: UIImage(named: "logo.png")
        )
    }
}
