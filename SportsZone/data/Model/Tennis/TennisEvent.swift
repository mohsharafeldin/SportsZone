//
//  TennisEvent.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 06/06/2026.
//

struct TennisEvent: Decodable, SportEvent {
    let eventKey: Int
    let eventDate: String
    let eventTime: String
    let firstPlayer: String?
    let secondPlayer: String?
    let firstPlayerLogo: String?
    let secondPlayerLogo: String?
    let finalResult: String?
    let leagueName: String?
    let leagueRound: String?
    let eventStatus: String?

    // Protocol computed properties
    var homeTeamName: String? { firstPlayer }
    var awayTeamName: String? { secondPlayer }
    var homeTeamLogo: String? { firstPlayerLogo }
    var awayTeamLogo: String? { secondPlayerLogo }

    enum CodingKeys: String, CodingKey {
        case eventKey = "event_key"
        case eventDate = "event_date"
        case eventTime = "event_time"
        case firstPlayer = "event_first_player"
        case secondPlayer = "event_second_player"
        case firstPlayerLogo = "event_first_player_logo"
        case secondPlayerLogo = "event_second_player_logo"
        case finalResult = "event_final_result"
        case leagueName = "league_name"
        case leagueRound = "league_round"
        case eventStatus = "event_status"
    }
}
