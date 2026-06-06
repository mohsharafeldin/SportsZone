//
//  BasketballEvent.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 06/06/2026.
//

import Foundation

struct BasketballEvent: Decodable, SportEvent {
    let eventKey: Int
    let eventDate: String
    let eventTime: String
    let homeTeamName: String?
    let awayTeamName: String?
    let homeTeamLogo: String?
    let awayTeamLogo: String?
    let finalResult: String?
    let leagueName: String?
    let leagueRound: String?
    let eventStatus: String?

    enum CodingKeys: String, CodingKey {
        case eventKey = "event_key"
        case eventDate = "event_date"
        case eventTime = "event_time"
        case homeTeamName = "event_home_team"
        case awayTeamName = "event_away_team"
        case homeTeamLogo = "event_home_team_logo"
        case awayTeamLogo = "event_away_team_logo"  
        case finalResult = "event_final_result"
        case leagueName = "league_name"
        case leagueRound = "league_round"
        case eventStatus = "event_status"
    }
}
