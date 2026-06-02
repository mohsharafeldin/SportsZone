//
//  EventModel.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 20/05/2026.
//

import Foundation

struct EventResponse: Decodable {
    let success: Int
    let result: [Event]?
}

struct Event: Decodable {
    let eventKey: Int
    let eventDate: String
    let eventTime: String
    let team1Name: String?
    let team2Name: String?
    let team1Logo: String?
    let team2Logo: String?
    let eventFinalResult: String?
    let leagueName: String?
    let leagueRound: String?
    let eventStatus: String?

    enum CodingKeys: String, CodingKey {
        case eventKey = "event_key"
        case eventDate = "event_date"
        case eventTime = "event_time"
        case team1Name = "event_home_team"
        case team2Name = "event_away_team"
        case team1Logo = "home_team_logo"
        case team2Logo = "away_team_logo"
        case eventFinalResult = "event_final_result"
        case leagueName = "league_name"
        case leagueRound = "league_round"
        case eventStatus = "event_status"
    }
}
