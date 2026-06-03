//
//  Coach.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 24/05/2026.
//

struct Coach: Decodable {
    let coachName: String
    
    enum CodingKeys: String, CodingKey{
        case coachName = "coach_name"
    }
}
