//
//  TeamModel.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 20/05/2026.
//

import Foundation

struct TeamResponse: Decodable {
    let success: Int
    let result: [Team]
}

struct Team: Decodable {
    let teamKey: Int
    let teamName: String
    let teamLogo: String

    enum CodingKeys: String, CodingKey {
        case teamKey  = "team_key"
        case teamName = "team_name"
        case teamLogo = "team_logo"
    }
}
