//
//  MockTeamsRepo.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 03/06/2026.
//

import XCTest
@testable import SportsZone 

// MARK: - Mock Repository
 
final class MockTeamsRepo: TeamsRepoProtocol {
    var teamDetailsResult: Result<[Team], Error>?
    var fetchTeamDetailsCallCount = 0
    var lastSportPassed: SportType?
    var lastTeamIDPassed: String?
 
    func fetchTeamDetails(
        sport: SportType,
        teamID: String,
        completion: @escaping (Result<[Team], Error>) -> Void
    ) {
        fetchTeamDetailsCallCount += 1
        lastSportPassed  = sport
        lastTeamIDPassed = teamID
        if let result = teamDetailsResult { completion(result) }
    }
 
    func reset() {
        teamDetailsResult         = nil
        fetchTeamDetailsCallCount = 0
        lastSportPassed           = nil
        lastTeamIDPassed          = nil
    }
}
