//
//  Untitled.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 03/06/2026.
//

import XCTest

@testable import SportsZone

private enum TestError: LocalizedError {
    case events, teams
    var errorDescription: String? {
        switch self {
        case .events: return "Events fetch failed"
        case .teams: return "Teams fetch failed"
        }
    }
}

// Build a dummy Event
private func makeEvent(
    key: Int = Int.random(in: 1...9999),
    dateString: String,
    team1: String = "Home FC",
    team2: String = "Away FC"
) -> SportEvent {
    let json = """
    {
        "event_key": \(key),
        "event_date": "\(dateString)",
        "event_time": "18:00",
        "event_home_team": "\(team1)",
        "event_away_team": "\(team2)",
        "home_team_logo": null,
        "away_team_logo": null,
        "event_final_result": null,
        "league_name": "Test League",
        "league_round": "1",
        "event_status": null
    }
    """
    return try! JSONDecoder().decode(SportEvent.self, from: json.data(using: .utf8)!)
}

// Build a dummy Team
private func makeTeam(key: Int = Int.random(in: 1...9999)) -> Team {
    let json = """
    {
        "team_key": \(key),
        "team_name": "Team \(key)",
        "team_logo": "https://example.com/logo/\(key).png",
        "players": null,
        "coaches": null
    }
    """
    return try! JSONDecoder().decode(Team.self, from: json.data(using: .utf8)!)
}

// Dates
private func todayString() -> String { formattedDate(Date()) }

private func pastDateString() -> String {
    let past = Calendar.current.date(byAdding: .day, value: -5, to: Date())!
    return formattedDate(past)
}

private func futureDateString() -> String {
    let future = Calendar.current.date(byAdding: .day, value: +5, to: Date())!
    return formattedDate(future)
}


final class LeaguesDetailsPresenterTests: XCTestCase {

    var presenter: LeaguesDetailsPresenter!
    var mockView: MockLeaguesDetailsView!
    var mockRepo: MockLeaguesRepo!

    override func setUp() {
        super.setUp()
        mockRepo = MockLeaguesRepo()
        mockView = MockLeaguesDetailsView()
        presenter = LeaguesDetailsPresenter(repository: mockRepo)
        presenter.view = mockView
    }

    override func tearDown() {
        presenter = nil
        mockView = nil
        mockRepo = nil
        super.tearDown()
    }

    // Initial State Tests

    func test_initialState_upcomingEventsIsEmpty() {
        XCTAssertTrue(presenter.upcomingEvents.isEmpty)
    }

    func test_initialState_latestEventsIsEmpty() {
        XCTAssertTrue(presenter.latestEvents.isEmpty)
    }

    func test_initialState_teamsIsEmpty() {
        XCTAssertTrue(presenter.teams.isEmpty)
    }

    func test_initialState_isLoadingIsFalse() {
        XCTAssertFalse(presenter.isLoading)
    }

    // Loading State Tests

    func test_loadData_setsIsLoadingTrueImmediately() {
        presenter.loadData(
            sport: .football,
            leagueID: "1",
            from: "2024-01-01",
            to: "2024-12-31"
        )
        XCTAssertTrue(presenter.isLoading)
    }

    func test_loadData_callsShowLoadingOnView() {
        presenter.loadData(
            sport: .football,
            leagueID: "1",
            from: "2024-01-01",
            to: "2024-12-31"
        )
        XCTAssertTrue(mockView.showLoadingCalled)
    }

    // Both Succeed Tests

    func test_loadData_bothSucceed_callsHideLoading() {
        mockRepo.eventsResult = .success([])
        mockRepo.teamsResult = .success([])

        loadAndWait()

        XCTAssertTrue(mockView.hideLoadingCalled)
    }

    func test_loadData_bothSucceed_callsReloadData() {
        mockRepo.eventsResult = .success([])
        mockRepo.teamsResult = .success([])

        loadAndWait()

        XCTAssertTrue(mockView.reloadDataCalled)
    }

    func test_loadData_bothSucceed_setsIsLoadingFalse() {
        mockRepo.eventsResult = .success([])
        mockRepo.teamsResult = .success([])

        loadAndWait()

        XCTAssertFalse(presenter.isLoading)
    }

    func test_loadData_bothSucceed_doesNotShowError() {
        mockRepo.eventsResult = .success([])
        mockRepo.teamsResult = .success([])

        loadAndWait()

        XCTAssertFalse(mockView.showErrorCalled)
    }

    // Event Filtering Tests

    func test_loadData_futureEventsGoToUpcoming() {
        let future = makeEvent(dateString: futureDateString())
        mockRepo.eventsResult = .success([future])
        mockRepo.teamsResult = .success([])

        loadAndWait()

        XCTAssertEqual(presenter.upcomingEvents.count, 1)
        XCTAssertTrue(presenter.latestEvents.isEmpty)
    }

    func test_loadData_pastEventsGoToLatest() {
        let past = makeEvent(dateString: pastDateString())
        mockRepo.eventsResult = .success([past])
        mockRepo.teamsResult = .success([])

        loadAndWait()

        XCTAssertEqual(presenter.latestEvents.count, 1)
        XCTAssertTrue(presenter.upcomingEvents.isEmpty)
    }

    func test_loadData_todayEventGoesToUpcoming() {
        let todayEvent = makeEvent(dateString: todayString())
        mockRepo.eventsResult = .success([todayEvent])
        mockRepo.teamsResult = .success([])

        loadAndWait()

        XCTAssertEqual(presenter.upcomingEvents.count, 1)
        XCTAssertTrue(presenter.latestEvents.isEmpty)
    }

    func test_loadData_mixedEvents_splitCorrectly() {
        let past1 = makeEvent(dateString: pastDateString())
        let past2 = makeEvent(dateString: pastDateString())
        let future = makeEvent(dateString: futureDateString())
        mockRepo.eventsResult = .success([past1, past2, future])
        mockRepo.teamsResult = .success([])

        loadAndWait()

        XCTAssertEqual(presenter.upcomingEvents.count, 1)
        XCTAssertEqual(presenter.latestEvents.count, 2)
    }

    func test_loadData_emptyEvents_bothArraysEmpty() {
        mockRepo.eventsResult = .success([])
        mockRepo.teamsResult = .success([])

        loadAndWait()

        XCTAssertTrue(presenter.upcomingEvents.isEmpty)
        XCTAssertTrue(presenter.latestEvents.isEmpty)
    }

    // Teams Tests

    func test_loadData_teamsSucceed_populatesTeams() {
        let teams = [makeTeam(), makeTeam(), makeTeam()]
        mockRepo.eventsResult = .success([])
        mockRepo.teamsResult = .success(teams)

        loadAndWait()

        XCTAssertEqual(presenter.teams.count, 3)
    }

    func test_loadData_emptyTeams_teamsArrayIsEmpty() {
        mockRepo.eventsResult = .success([])
        mockRepo.teamsResult = .success([])

        loadAndWait()

        XCTAssertTrue(presenter.teams.isEmpty)
    }

    // Failure Tests

    func test_loadData_eventsFail_showsError() {
        mockRepo.eventsResult = .failure(TestError.events)
        mockRepo.teamsResult = .success([])

        loadAndWait()

        XCTAssertTrue(mockView.showErrorCalled)
        XCTAssertTrue(
            mockView.errorMessages.contains(
                TestError.events.localizedDescription
            )
        )
    }

    func test_loadData_teamsFail_showsError() {
        mockRepo.eventsResult = .success([])
        mockRepo.teamsResult = .failure(TestError.teams)

        loadAndWait()

        XCTAssertTrue(mockView.showErrorCalled)
        XCTAssertTrue(
            mockView.errorMessages.contains(
                TestError.teams.localizedDescription
            )
        )
    }

    func test_loadData_bothFail_showsTwoErrors() {
        mockRepo.eventsResult = .failure(TestError.events)
        mockRepo.teamsResult = .failure(TestError.teams)

        loadAndWait()

        XCTAssertEqual(mockView.errorMessages.count, 2)
    }

    func test_loadData_eventsFail_teamsStillPopulated() {
        let teams = [makeTeam(), makeTeam()]
        mockRepo.eventsResult = .failure(TestError.events)
        mockRepo.teamsResult = .success(teams)

        loadAndWait()

        XCTAssertEqual(presenter.teams.count, 2)
    }

    func test_loadData_teamsFail_eventsStillPopulated() {
        let future = makeEvent(dateString: futureDateString())
        mockRepo.eventsResult = .success([future])
        mockRepo.teamsResult = .failure(TestError.teams)

        loadAndWait()

        XCTAssertEqual(presenter.upcomingEvents.count, 1)
    }

    func test_loadData_bothFail_hideLoadingStillCalled() {
        mockRepo.eventsResult = .failure(TestError.events)
        mockRepo.teamsResult = .failure(TestError.teams)

        loadAndWait()

        XCTAssertTrue(mockView.hideLoadingCalled)
    }

    func test_loadData_bothFail_reloadDataStillCalled() {
        mockRepo.eventsResult = .failure(TestError.events)
        mockRepo.teamsResult = .failure(TestError.teams)

        loadAndWait()

        XCTAssertTrue(mockView.reloadDataCalled)
    }

    func test_loadData_bothFail_isLoadingSetFalse() {
        mockRepo.eventsResult = .failure(TestError.events)
        mockRepo.teamsResult = .failure(TestError.teams)

        loadAndWait()

        XCTAssertFalse(presenter.isLoading)
    }

    // Repository Call Verification

    func test_loadData_callsFetchEventsOnce() {
        mockRepo.eventsResult = .success([])
        mockRepo.teamsResult = .success([])

        loadAndWait()

        XCTAssertEqual(mockRepo.fetchEventsCallCount, 1)
    }

    func test_loadData_callsFetchTeamsOnce() {
        mockRepo.eventsResult = .success([])
        mockRepo.teamsResult = .success([])

        loadAndWait()

        XCTAssertEqual(mockRepo.fetchTeamsCallCount, 1)
    }

    // No View

    func test_loadData_nilView_doesNotCrash() {
        presenter.view = nil
        mockRepo.eventsResult = .success([])
        mockRepo.teamsResult = .success([])

        XCTAssertNoThrow(loadAndWait())
    }

    // Multiple Calls

    func test_loadData_calledTwice_dataIsRefreshed() {
        // First call: future event
        mockRepo.eventsResult = .success([
            makeEvent(dateString: futureDateString())
        ])
        mockRepo.teamsResult = .success([])
        loadAndWait()
        XCTAssertEqual(presenter.upcomingEvents.count, 1)

        // Second call: empty
        mockRepo.reset()
        mockView.reset()
        mockRepo.eventsResult = .success([])
        mockRepo.teamsResult = .success([])
        loadAndWait()
        XCTAssertTrue(presenter.upcomingEvents.isEmpty)
    }

    private func loadAndWait(
        sport: SportType = .football,
        leagueID: String = "42",
        from: String = "2024-01-01",
        to: String = "2024-12-31"
    ) {
        presenter.loadData(sport: sport, leagueID: leagueID, from: from, to: to)
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.1))
    }
}
