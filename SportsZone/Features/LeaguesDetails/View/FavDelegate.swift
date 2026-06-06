//
//  FavDelegate.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 06/06/2026.
//

import Foundation
protocol FavDelegate: AnyObject {
    
    func didTapFavourite(at cell: LeagueInfoCell)
}
