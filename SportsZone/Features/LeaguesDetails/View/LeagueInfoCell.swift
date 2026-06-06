//
//  LeagueInfoCell.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 06/06/2026.
//

import UIKit

class LeagueInfoCell: UICollectionViewCell {
    
    @IBOutlet weak var leagueNameLable: UILabel!
    @IBOutlet weak var leagueLogo: UIImageView!
    @IBOutlet weak var favBtn: UIButton!
    
    weak var delegate : FavDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.setupUI()
        self.setupShadow()

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath =
            UIBezierPath(
                roundedRect: bounds,
                cornerRadius: 25
            ).cgPath
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hideSkeleton()
    }
    
    func config(league: League){
        leagueNameLable.text = league.leagueName
        leagueLogo.sd_setImage(
            with: URL(string: league.leagueLogo  ?? ""),
            placeholderImage: UIImage(named: "logo.png")
        )
    }
    
    @IBAction func didFavSelected(_ sender: UIButton) {
        delegate?.didTapFavourite(at: self)
    }
    
    private func setupUI(){
        leagueLogo.layer.cornerRadius = leagueLogo.frame.width / 2
        leagueLogo.clipsToBounds = true
        
        leagueNameLable.font = UIFont(name: "Nunito-SemiBold", size: 18)
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
