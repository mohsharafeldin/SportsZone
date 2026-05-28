//
//  PlayerCell.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 24/05/2026.
//

import UIKit

class PlayerCell: UITableViewCell {

    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerDetailesLabel: UILabel!
    @IBOutlet weak var playerNumerLabel: UILabel!
    @IBOutlet weak var playerRatingLabel: UILabel!
    @IBOutlet weak var playerYellowCardsLabel: UILabel!
    @IBOutlet weak var playerRedCardsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = UIColor(named: "Background")
        contentView.backgroundColor = UIColor(named: "Surface")

        setupStyles()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(top: 6, left: 4, bottom: 6, right: 4)
        )
        
        let size = min(playerImage.frame.width, playerImage.frame.height)
        playerImage.layer.cornerRadius = size / 2
        playerImage.clipsToBounds = true
        
        addShadow(to: contentView)
    }

    private func setupStyles() {
        playerNameLabel.font = UIFont(name: "Nunito-Bold", size: 20)
        playerDetailesLabel.font = UIFont(name: "Nunito-SemiBold", size: 18)
        playerNumerLabel.font = UIFont(name: "Nunito-SemiBold", size: 20)
        playerRatingLabel.font = UIFont(name: "Nunito-Regular", size: 16)
        playerYellowCardsLabel.font = UIFont(name: "Nunito-Regular", size: 16)
        playerRedCardsLabel.font = UIFont(name: "Nunito-Regular", size: 16)
    }

    func config(player: Player) {
        if let imageString = player.playerImage,
            let url = URL(string: imageString),
            !imageString.isEmpty
        {

            playerImage.sd_setImage(
                with: url,
                placeholderImage: UIImage(systemName: "person.fill")
            )

        } else {
            playerImage.image = UIImage(systemName: "person.fill")
        }

        playerNameLabel.text = player.playerName ?? "Unknown Player"

        let type = player.playerType ?? "Unknown"
        let age = player.playerAge ?? "N/A"

        playerDetailesLabel.text = "\(type) | age: \(age)"
        playerNumerLabel.text = player.playerNumber ?? "-"
        playerRatingLabel.text =
            player.playerRating?.isEmpty == false ? player.playerRating : "0"
        playerYellowCardsLabel.text =
            player.playerYellowCards?.isEmpty == false
            ? player.playerYellowCards : "0"
        playerRedCardsLabel.text =
            player.playerRedCards?.isEmpty == false
            ? player.playerRedCards : "0"
    }
}
