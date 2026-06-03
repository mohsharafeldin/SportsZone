//
//  TeamsRepoTests.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 03/06/2026.
//

import XCTest

@testable import SportsZone

final class TeamsRepoTests: XCTestCase {

    var repo: TeamsRepo!
    var mockNetwork: MockNetworkManager!

    override func setUp() {
        super.setUp()
        mockNetwork = MockNetworkManager()
        repo = TeamsRepo(newtwork: mockNetwork)
    }

    override func tearDown() {
        repo = nil
        mockNetwork = nil
        super.tearDown()
    }

    // MARK: fetchTeamDetails

    func test_fetchTeamDetails_success_returnsTeams() {
        // Given
        let teams = [
            Team(
                teamKey: 10,
                teamName: "Arsenal",
                teamLogo: "logo.png",
                players: nil,
                coaches: nil
            )
        ]
        mockNetwork.resultToReturn = TeamResponse(success: 1, result: teams)

        // When
        var receivedTeams: [Team]?
        repo.fetchTeamDetails(sport: .football, teamID: "10") { result in
            if case .success(let data) = result { receivedTeams = data }
        }

        // Then
        XCTAssertEqual(receivedTeams?.count, 1)
        XCTAssertEqual(receivedTeams?.first?.teamName, "Arsenal")
        XCTAssertEqual(receivedTeams?.first?.teamKey, 10)
    }

    func test_fetchTeamDetails_success_nilResult_returnsEmptyArray() {
        // Given
        mockNetwork.resultToReturn = TeamResponse(success: 1, result: nil)

        // When
        var receivedTeams: [Team]?
        repo.fetchTeamDetails(sport: .football, teamID: "10") { result in
            if case .success(let data) = result { receivedTeams = data }
        }

        // Then
        XCTAssertNotNil(receivedTeams)
        XCTAssertTrue(receivedTeams!.isEmpty)
    }

    func test_fetchTeamDetails_success_emptyResult_returnsEmptyArray() {
        // Given
        mockNetwork.resultToReturn = TeamResponse(success: 1, result: [])

        // When
        var receivedTeams: [Team]?
        repo.fetchTeamDetails(sport: .basketball, teamID: "99") { result in
            if case .success(let data) = result { receivedTeams = data }
        }

        // Then
        XCTAssertNotNil(receivedTeams)
        XCTAssertTrue(receivedTeams!.isEmpty)
    }

    func test_fetchTeamDetails_failure_returnsError() {
        // Given
        let expectedError = NSError(domain: "NetworkError", code: 500)
        mockNetwork.errorToReturn = expectedError

        // When
        var receivedError: Error?
        repo.fetchTeamDetails(sport: .football, teamID: "10") { result in
            if case .failure(let error) = result { receivedError = error }
        }

        // Then
        XCTAssertNotNil(receivedError)
        XCTAssertEqual((receivedError as NSError?)?.code, 500)
    }

    func test_fetchTeamDetails_failure_networkUnavailable() {
        // Given
        let networkError = NSError(
            domain: NSURLErrorDomain,
            code: NSURLErrorNotConnectedToInternet
        )
        mockNetwork.errorToReturn = networkError

        // When
        var receivedError: Error?
        repo.fetchTeamDetails(sport: .football, teamID: "10") { result in
            if case .failure(let error) = result { receivedError = error }
        }

        // Then
        XCTAssertEqual(
            (receivedError as NSError?)?.code,
            NSURLErrorNotConnectedToInternet
        )
    }

    func test_fetchTeamDetails_teamWithPlayersAndCoaches() {
        // Given
        let player = Player(
            playerKey: 2,
            playerImage: "",
            playerName: "Ali",
            playerNumber: "20",
            playerType: "GoalKeeper",
            playerAge: "34",
            playerRating: "3.4",
            playerYellowCards: "2",
            playerRedCards: "1"
        )
        let coach = Coach(coachName: "Ahmed")
        let teams = [
            Team(
                teamKey: 5,
                teamName: "Chelsea",
                teamLogo: "chelsea.png",
                players: [player],
                coaches: [coach]
            )
        ]
        mockNetwork.resultToReturn = TeamResponse(success: 1, result: teams)

        // When
        var receivedTeams: [Team]?
        repo.fetchTeamDetails(sport: .football, teamID: "5") { result in
            if case .success(let data) = result { receivedTeams = data }
        }

        // Then
        XCTAssertEqual(receivedTeams?.first?.teamName, "Chelsea")
        XCTAssertEqual(receivedTeams?.first?.teamKey, 5)
        XCTAssertEqual(receivedTeams?.first?.players?.count, 1)
        XCTAssertEqual(receivedTeams?.first?.coaches?.count, 1)
    }

    func test_fetchTeamDetails_multipleTeams_allReturned() {
        // Given
        let teams = (1...3).map { i in
            Team(
                teamKey: i,
                teamName: "Team \(i)",
                teamLogo: "logo\(i).png",
                players: nil,
                coaches: nil
            )
        }
        mockNetwork.resultToReturn = TeamResponse(success: 1, result: teams)

        // When
        var receivedTeams: [Team]?
        repo.fetchTeamDetails(sport: .football, teamID: "1") { result in
            if case .success(let data) = result { receivedTeams = data }
        }

        // Then
        XCTAssertEqual(receivedTeams?.count, 3)
    }

    func test_fetchTeamDetails_differentSports() {
        // Given
        let sports: [SportType] = [.football, .basketball, .cricket]
        let teams = [
            Team(
                teamKey: 1,
                teamName: "Team A",
                teamLogo: "",
                players: nil,
                coaches: nil
            )
        ]

        for sport in sports {
            mockNetwork.resultToReturn = TeamResponse(success: 1, result: teams)
            mockNetwork.errorToReturn = nil

            // When
            var receivedTeams: [Team]?
            repo.fetchTeamDetails(sport: sport, teamID: "1") { result in
                if case .success(let data) = result { receivedTeams = data }
            }

            // Then
            XCTAssertEqual(
                receivedTeams?.count,
                1,
                "Failed for sport: \(sport)"
            )
        }
    }
}
