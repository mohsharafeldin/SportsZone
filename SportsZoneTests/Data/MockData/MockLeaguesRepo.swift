//
//  MockLeaguesRepo.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 03/06/2026.
//

import XCTest

@testable import SportsZone

final class MockLeaguesRepo: LeaguesRepoProtocol {

    // MARK: Leagues

    var leaguesResult: Result<[League], Error>?

    var fetchLeaguesCalled = false

    var fetchLeaguesCallCount = 0

    var lastSportPassed: SportType?

    // MARK: Events

    var eventsResult: Result<[Event], Error>?

    var fetchEventsCalled = false

    var fetchEventsCallCount = 0

    // MARK: Teams

    var teamsResult: Result<[Team], Error>?

    var fetchTeamsCalled = false

    var fetchTeamsCallCount = 0

    func fetchLeagues(
        sport: SportType,
        completion: @escaping (Result<[League], Error>) -> Void
    ) {

        fetchLeaguesCalled = true

        fetchLeaguesCallCount += 1

        lastSportPassed = sport

        if let result = leaguesResult {
            completion(result)
        }
    }

    func fetchEvents(
        sport: SportType,
        leagueID: String,
        from: String,
        to: String,
        completion: @escaping (Result<[Event], Error>) -> Void
    ) {

        fetchEventsCalled = true

        fetchEventsCallCount += 1

        if let result = eventsResult {
            completion(result)
        }
    }

    func fetchTeams(
        sport: SportType,
        leagueID: String,
        completion: @escaping (Result<[Team], Error>) -> Void
    ) {

        fetchTeamsCalled = true

        fetchTeamsCallCount += 1

        if let result = teamsResult {
            completion(result)
        }
    }

    func reset() {

        leaguesResult = nil
        eventsResult = nil
        teamsResult = nil

        fetchLeaguesCalled = false
        fetchLeaguesCallCount = 0

        fetchEventsCalled = false
        fetchEventsCallCount = 0

        fetchTeamsCalled = false
        fetchTeamsCallCount = 0

        lastSportPassed = nil
    }
}
