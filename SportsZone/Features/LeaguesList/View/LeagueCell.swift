//
//  LeagueCell.swift
//  SportsZone
//
//  Created by mohamed sharaf on 01/06/2026.
//

import UIKit

class LeagueCell: UITableViewCell {

    
    @IBOutlet weak var leagueImage: UIImageView!
    
    @IBOutlet weak var leagueName: UILabel!
    
    @IBOutlet weak var countryImage: UIImageView!
    
    @IBOutlet weak var countryName: UILabel!
    weak var delegate: LeagueCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @IBAction func addOrDeleteFavorite(_ sender: Any) {
        delegate?.didTapFavourite(at: self)
    }
    
}
