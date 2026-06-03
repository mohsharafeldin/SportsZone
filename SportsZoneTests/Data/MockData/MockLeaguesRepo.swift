//
//  MockLeaguesRepo.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 03/06/2026.
//

import XCTest

@testable import SportsZone

// MARK: - Mock Repository

final class MockLeaguesRepo: LeaguesRepoProtocol {

    //Events setup
    var eventsResult: Result<[Event], Error>?
    var fetchEventsCalled = false
    var fetchEventsCallCount = 0

    //Teams setup
    var teamsResult: Result<[Team], Error>?
    var fetchTeamsCalled = false
    var fetchTeamsCallCount = 0

    func fetchEvents(
        sport: SportType,
        leagueID: String,
        from: String,
        to: String,
        completion: @escaping (Result<[Event], Error>) -> Void
    ) {
        fetchEventsCalled = true
        fetchEventsCallCount += 1
        if let result = eventsResult { completion(result) }
    }

    func fetchTeams(
        sport: SportType,
        leagueID: String,
        completion: @escaping (Result<[Team], Error>) -> Void
    ) {
        fetchTeamsCalled = true
        fetchTeamsCallCount += 1
        if let result = teamsResult { completion(result) }
    }

    func fetchLeagues(
        sport: SportsZone.SportType,
        completion: @escaping (Result<[SportsZone.League], any Error>) -> Void
    ) {
        
    }

    func reset() {
        eventsResult = nil
        teamsResult = nil
        fetchEventsCalled = false
        fetchEventsCallCount = 0
        fetchTeamsCalled = false
        fetchTeamsCallCount = 0
    }
}
