//
//  EventModel.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 20/05/2026.
//

import Foundation

struct SportEventResponse<T: Decodable>: Decodable {
    let success: Int
    let result: [T]?
}

protocol SportEvent {
    var eventKey: Int { get }
    var eventDate: String { get }
    var eventTime: String { get }
    var homeTeamName: String? { get }
    var awayTeamName: String? { get }
    var homeTeamLogo: String? { get }
    var awayTeamLogo: String? { get }
    var finalResult: String? { get }
    var leagueName: String? { get }
    var eventStatus: String? { get }
    var leagueRound: String? { get }
}
