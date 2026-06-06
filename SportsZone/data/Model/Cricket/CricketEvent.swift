//
//  CricketEvent.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 06/06/2026.
//

import Foundation

struct CricketEvent: Decodable, SportEvent {
    let eventKey: Int
    let eventDateStart: String?
    let eventDateStop: String?
    let eventTime: String
    let homeTeamName: String?
    let awayTeamName: String?
    let homeTeamLogo: String?
    let awayTeamLogo: String?
    let homeResult: String?
    let awayResult: String?
    let leagueName: String?
    let leagueRound: String?
    let eventStatus: String?

    // Protocol computed properties
    var eventDate: String { eventDateStart ?? "0" }
    var finalResult: String? {
        guard let h = homeResult, let a = awayResult else { return nil }
        return "\(h) - \(a)"
    }

    enum CodingKeys: String, CodingKey {
        case eventKey = "event_key"
        case eventDateStart = "event_date_start"
        case eventDateStop = "event_date_stop"
        case eventTime = "event_time"
        case homeTeamName = "event_home_team"
        case awayTeamName = "event_away_team"
        case homeTeamLogo = "event_home_team_logo"
        case awayTeamLogo = "event_away_team_logo"
        case homeResult = "event_home_final_result"
        case awayResult = "event_away_final_result"  
        case leagueName = "league_name"
        case leagueRound = "league_round"
        case eventStatus = "event_status"
    }
}
