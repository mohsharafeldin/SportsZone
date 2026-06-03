//
//  League.swift
//  SportsZone
//
//  Created by mohamed sharaf on 01/06/2026.
//

import Foundation

struct LeagueResponse: Codable {
    let result: [League]
}

struct League: Codable {
    
    let leagueKey: Int?
    let leagueName: String?
    let countryName: String?
    let leagueLogo: String?
    let countryLogo: String?
    
    enum CodingKeys: String, CodingKey {
        case leagueKey = "league_key"
        case leagueName = "league_name"
        case countryName = "country_name"
        case leagueLogo = "league_logo"
        case countryLogo = "country_logo"
    }
}
