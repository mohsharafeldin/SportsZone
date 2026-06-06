//
//  Player.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 24/05/2026.
//

struct Player: Decodable {
    let playerKey: Int
    let playerImage: String?
    let playerName: String?
    let playerNumber: String?
    let playerType: String?
    let playerAge: String?
    let playerRating: String?
    let playerYellowCards: String?
    let playerRedCards: String?
    
    enum CodingKeys: String, CodingKey{
        case playerKey = "player_key"
        case playerImage = "player_image"
        case playerName = "player_name"
        case playerNumber = "player_number"
        case playerType = "player_type"
        case playerAge = "player_age"
        case playerRating = "player_rating"
        case playerYellowCards = "player_yellow_cards"
        case playerRedCards = "player_red_cards"
    }

}
