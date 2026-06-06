//
//  LeaguesRepoTests.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 03/06/2026.
//

import XCTest

@testable import SportsZone

final class LeaguesRepoTests: XCTestCase {

    var repo: LeaguesRepo!
    var mockNetwork: MockNetworkManager!

    override func setUp() {
        super.setUp()
        mockNetwork = MockNetworkManager()
        repo = LeaguesRepo(network: mockNetwork)
    }

    override func tearDown() {
        repo = nil
        mockNetwork = nil
        super.tearDown()
    }

    // MARK: fetchLeagues

    func test_fetchLeagues_success_returnsLeagues() {
        // Given
        let leagues = [
            League(
                leagueKey: 1,
                leagueName: "Premier League",
                countryName: "England",
                leagueLogo: nil,
                countryLogo: nil
            ),
            League(
                leagueKey: 2,
                leagueName: "La Liga",
                countryName: "Spain",
                leagueLogo: nil,
                countryLogo: nil
            ),
        ]
        mockNetwork.resultToReturn = LeagueResponse(result: leagues)

        // When
        var receivedLeagues: [League]?
        repo.fetchLeagues(sport: .football) { result in
            if case .success(let data) = result { receivedLeagues = data }
        }

        // Then
        XCTAssertEqual(receivedLeagues?.count, 2)
        XCTAssertEqual(receivedLeagues?.first?.leagueName, "Premier League")
        XCTAssertEqual(receivedLeagues?.last?.leagueKey, 2)
    }

    func test_fetchLeagues_success_emptyList() {
        // Given
        mockNetwork.resultToReturn = LeagueResponse(result: [])

        // When
        var receivedLeagues: [League]?
        repo.fetchLeagues(sport: .basketball) { result in
            if case .success(let data) = result { receivedLeagues = data }
        }

        // Then
        XCTAssertNotNil(receivedLeagues)
        XCTAssertTrue(receivedLeagues!.isEmpty)
    }

    func test_fetchLeagues_failure_returnsError() {
        // Given
        let expectedError = NSError(domain: "NetworkError", code: 404)
        mockNetwork.errorToReturn = expectedError

        // When
        var receivedError: Error?
        repo.fetchLeagues(sport: .football) { result in
            if case .failure(let error) = result { receivedError = error }
        }

        // Then
        XCTAssertNotNil(receivedError)
        XCTAssertEqual((receivedError as NSError?)?.code, 404)
    }

    func test_fetchLeagues_leagueWithNilOptionalFields() {
        // Given
        let leagues = [
            League(
                leagueKey: nil,
                leagueName: nil,
                countryName: nil,
                leagueLogo: nil,
                countryLogo: nil
            )
        ]
        mockNetwork.resultToReturn = LeagueResponse(result: leagues)

        // When
        var receivedLeagues: [League]?
        repo.fetchLeagues(sport: .football) { result in
            if case .success(let data) = result { receivedLeagues = data }
        }

        // Then
        XCTAssertEqual(receivedLeagues?.count, 1)
        XCTAssertNil(receivedLeagues?.first?.leagueName)
    }

    // MARK: fetchTeams

    func test_fetchTeams_success_returnsTeams() {
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
        repo.fetchTeams(sport: .football, leagueID: "152") { result in
            if case .success(let data) = result { receivedTeams = data }
        }

        // Then
        XCTAssertEqual(receivedTeams?.count, 1)
        XCTAssertEqual(receivedTeams?.first?.teamName, "Arsenal")
    }

    func test_fetchTeams_success_nilResult_returnsEmptyArray() {
        // Given
        mockNetwork.resultToReturn = TeamResponse(success: 1, result: nil)

        // When
        var receivedTeams: [Team]?
        repo.fetchTeams(sport: .football, leagueID: "152") { result in
            if case .success(let data) = result { receivedTeams = data }
        }

        // Then
        XCTAssertNotNil(receivedTeams)
        XCTAssertTrue(receivedTeams!.isEmpty)
    }

    func test_fetchTeams_failure_returnsError() {
        // Given
        mockNetwork.errorToReturn = NSError(domain: "NetworkError", code: 500)

        // When
        var receivedError: Error?
        repo.fetchTeams(sport: .basketball, leagueID: "99") { result in
            if case .failure(let error) = result { receivedError = error }
        }

        // Then
        XCTAssertNotNil(receivedError)
    }

    func test_fetchTeams_teamWithPlayersAndCoaches() {
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
                teamLogo: "",
                players: [player],
                coaches: [coach]
            )
        ]
        mockNetwork.resultToReturn = TeamResponse(success: 1, result: teams)

        // When
        var receivedTeams: [Team]?
        repo.fetchTeams(sport: .football, leagueID: "152") { result in
            if case .success(let data) = result { receivedTeams = data }
        }

        // Then
        XCTAssertEqual(receivedTeams?.first?.players?.count, 1)
        XCTAssertEqual(receivedTeams?.first?.coaches?.count, 1)
    }

    // MARK: fetchEvents

    func test_fetchEvents_success_returnsEvents() {
        // Given
        let events = [
            SportEvent(
                eventKey: 1,
                eventDate: "2024-01-20",
                eventTime: "20:00",
                team1Name: "Arsenal",
                team2Name: "Chelsea",
                team1Logo: nil,
                team2Logo: nil,
                eventFinalResult: "2-1",
                leagueName: "EPL",
                leagueRound: "22",
                eventStatus: "Finished"
            )
        ]
        mockNetwork.resultToReturn = SportEventResponse(success: 1, result: events)

        // When
        var receivedEvents: [SportEvent]?
        repo.fetchEvents(
            sport: .football,
            leagueID: "152",
            from: "2024-01-01",
            to: "2024-01-31"
        ) { result in
            if case .success(let data) = result { receivedEvents = data }
        }

        // Then
        XCTAssertEqual(receivedEvents?.count, 1)
        XCTAssertEqual(receivedEvents?.first?.team1Name, "Arsenal")
        XCTAssertEqual(receivedEvents?.first?.eventFinalResult, "2-1")
    }

    func test_fetchEvents_success_nilResult_returnsEmptyArray() {
        // Given
        mockNetwork.resultToReturn = SportEventResponse(success: 1, result: nil)

        // When
        var receivedEvents: [SportEvent]?
        repo.fetchEvents(
            sport: .football,
            leagueID: "152",
            from: "2024-01-01",
            to: "2024-01-31"
        ) { result in
            if case .success(let data) = result { receivedEvents = data }
        }

        // Then
        XCTAssertTrue(receivedEvents!.isEmpty)
    }

    func test_fetchEvents_failure_returnsError() {
        // Given
        mockNetwork.errorToReturn = NSError(domain: "NetworkError", code: 503)

        // When
        var receivedError: Error?
        repo.fetchEvents(
            sport: .cricket,
            leagueID: "1",
            from: "2024-01-01",
            to: "2024-12-31"
        ) { result in
            if case .failure(let error) = result { receivedError = error }
        }

        // Then
        XCTAssertNotNil(receivedError)
        XCTAssertEqual((receivedError as NSError?)?.code, 503)
    }

    func test_fetchEvents_multipleEvents_allReturned() {
        // Given
        let events = (1...5).map { i in
            SportEvent(
                eventKey: i,
                eventDate: "2024-01-\(i + 10)",
                eventTime: "18:00",
                team1Name: "Team A",
                team2Name: "Team B",
                team1Logo: nil,
                team2Logo: nil,
                eventFinalResult: nil,
                leagueName: "EPL",
                leagueRound: "\(i)",
                eventStatus: "NS"
            )
        }
        mockNetwork.resultToReturn = SportEventResponse(success: 1, result: events)

        // When
        var receivedEvents: [SportEvent]?
        repo.fetchEvents(
            sport: .football,
            leagueID: "152",
            from: "2024-01-10",
            to: "2024-01-15"
        ) { result in
            if case .success(let data) = result { receivedEvents = data }
        }

        // Then
        XCTAssertEqual(receivedEvents?.count, 5)
    }

    func test_fetchEvents_eventWithNilOptionalFields() {
        // Give
        let events = [
            SportEvent(
                eventKey: 99,
                eventDate: "2024-06-01",
                eventTime: "21:00",
                team1Name: nil,
                team2Name: nil,
                team1Logo: nil,
                team2Logo: nil,
                eventFinalResult: nil,
                leagueName: nil,
                leagueRound: nil,
                eventStatus: "NS"
            )
        ]
        mockNetwork.resultToReturn = SportEventResponse(success: 1, result: events)

        // When
        var receivedEvents: [SportEvent]?
        repo.fetchEvents(
            sport: .football,
            leagueID: "152",
            from: "2024-06-01",
            to: "2024-06-01"
        ) { result in
            if case .success(let data) = result { receivedEvents = data }
        }

        // Then
        XCTAssertEqual(receivedEvents?.first?.eventKey, 99)
        XCTAssertNil(receivedEvents?.first?.team1Name)
        XCTAssertEqual(receivedEvents?.first?.eventStatus, "NS")
    }
}
