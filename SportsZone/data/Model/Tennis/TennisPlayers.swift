//
//  TennisPlayers.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 06/06/2026.
//

import Foundation

struct TennisPlayersResponse: Decodable {
    let success: Int
    let result: [TennisPlayer]?
}

struct TennisPlayer: Decodable {
    let playerKey: Int
    let playerName: String? 
    let playerCountry: String?
    let playerBday: String?
    let playerLogo: String?

    var cleanedPlayerName: String {
            return playerName?
                .components(separatedBy: "/")
                .joined(separator: " ")
                .trimmingCharacters(in: .whitespaces) ?? ""
        }
    
    enum CodingKeys: String, CodingKey {
        case playerKey     = "player_key"
        case playerName    = "player_name"
        case playerCountry = "player_country"
        case playerBday    = "player_bday"
        case playerLogo    = "player_logo"
    }
}
