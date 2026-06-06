//
// LeaguesPresenterTests.swift
//  SportsZoneTests
//
//  Created by mohamed sharaf on 04/06/2026.
//



import XCTest
@testable import SportsZone
private enum TestError: LocalizedError {

    case network

    var errorDescription: String? {
        return "Network Error"
    }
}

final class LeaguesPresenterTests: XCTestCase {

    var presenter: LeaguesPresenter!

    var mockView: MockLeaguesView!

    var mockRepo: MockLeaguesRepo!

    var mockReachability: MockReachability!
    private func makeLeague(
        key: Int = 1,
        name: String = "Premier League"
    ) -> League {

        League(
            leagueKey: key,
            leagueName: name,
            countryName: "England",
            leagueLogo: nil,
            countryLogo: nil
        )
    }

    override func setUp() {

        super.setUp()

        mockView = MockLeaguesView()

        mockRepo = MockLeaguesRepo()

        mockReachability = MockReachability()

        presenter = LeaguesPresenter(
            view: mockView,
            repo: mockRepo,
            reachability: mockReachability
        )
    }

    override func tearDown() {

        presenter = nil

        mockView = nil

        mockRepo = nil

        mockReachability = nil

        super.tearDown()
    }

    // MARK: Initial State

    func test_initialState_leaguesEmpty() {

        XCTAssertTrue(
            presenter.leagues.isEmpty
        )
    }

    func test_initialState_filteredLeaguesEmpty() {

        XCTAssertTrue(
            presenter.filteredLeagues.isEmpty
        )
    }

    // MARK: Reachability

    func test_canOpenLeagueDetails_whenConnected_returnsTrue() {

        mockReachability.connected = true

        XCTAssertTrue(
            presenter.canOpenLeagueDetails()
        )
    }

    func test_canOpenLeagueDetails_whenDisconnected_returnsFalse() {

        mockReachability.connected = false

        XCTAssertFalse(
            presenter.canOpenLeagueDetails()
        )
    }

    // MARK: Success

    func test_getLeagues_success_storesLeagues() {

        let leagues = [
            makeLeague(),
            makeLeague(key: 2)
        ]

        mockRepo.leaguesResult = .success(leagues)

        presenter.getLeagues(for: .football)

        XCTAssertEqual(
            presenter.leagues.count,
            2
        )
    }

    func test_getLeagues_success_updatesFilteredLeagues() {

        let leagues = [
            makeLeague(),
            makeLeague(key: 2)
        ]

        mockRepo.leaguesResult = .success(leagues)

        presenter.getLeagues(for: .football)

        XCTAssertEqual(
            presenter.filteredLeagues.count,
            2
        )
    }

    func test_getLeagues_callsRepositoryOnce() {

        mockRepo.leaguesResult = .success([])

        presenter.getLeagues(for: .football)

        XCTAssertEqual(
            mockRepo.fetchLeaguesCallCount,
            1
        )
    }

    func test_getLeagues_passesSportCorrectly() {

        mockRepo.leaguesResult = .success([])

        presenter.getLeagues(for: .basketball)

        XCTAssertEqual(
            mockRepo.lastSportPassed,
            .basketball
        )
    }

    // MARK: Failure

    func test_getLeagues_failure_doesNotStoreData() {

        mockRepo.leaguesResult =
            .failure(TestError.network)

        presenter.getLeagues(for: .football)

        XCTAssertTrue(
            presenter.leagues.isEmpty
        )
    }

    // MARK: Search

    func test_searchLeague_emptyText_returnsAllLeagues() {

        presenter.leagues = [
            makeLeague(name: "Premier League"),
            makeLeague(key: 2, name: "La Liga")
        ]

        presenter.searchLeague(text: "")

        XCTAssertEqual(
            presenter.filteredLeagues.count,
            2
        )
    }

    func test_searchLeague_findsSingleLeague() {

        presenter.leagues = [
            makeLeague(name: "Premier League"),
            makeLeague(key: 2, name: "La Liga")
        ]

        presenter.searchLeague(text: "premier")

        XCTAssertEqual(
            presenter.filteredLeagues.count,
            1
        )

        XCTAssertEqual(
            presenter.filteredLeagues.first?.leagueName,
            "Premier League"
        )
    }

    func test_searchLeague_caseInsensitive() {

        presenter.leagues = [
            makeLeague(name: "Premier League")
        ]

        presenter.searchLeague(text: "PREMIER")

        XCTAssertEqual(
            presenter.filteredLeagues.count,
            1
        )
    }

    func test_searchLeague_noMatches() {

        presenter.leagues = [
            makeLeague(name: "Premier League")
        ]

        presenter.searchLeague(text: "Egypt")

        XCTAssertTrue(
            presenter.filteredLeagues.isEmpty
        )
    }

    func test_searchLeague_callsRenderLeagues() {

        presenter.leagues = [
            makeLeague()
        ]

        presenter.searchLeague(text: "")

        XCTAssertTrue(
            mockView.renderLeaguesCalled
        )
    }

    // MARK: Nil View

    func test_getLeagues_nilView_doesNotCrash() {

        presenter.view = nil

        mockRepo.leaguesResult =
            .success([makeLeague()])

        XCTAssertNoThrow(
            presenter.getLeagues(for: .football)
        )
    }

    func test_searchLeague_nilView_doesNotCrash() {

        presenter.view = nil

        XCTAssertNoThrow(
            presenter.searchLeague(text: "")
        )
    }
    
    func test_getLeagues_success_callsRenderLeagues() {

        let exp = expectation(
            description: "render leagues"
        )

        mockRepo.leaguesResult = .success([
            makeLeague()
        ])

        presenter.getLeagues(for: .football)

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.1
        ) {

            XCTAssertTrue(
                self.mockView.renderLeaguesCalled
            )

            exp.fulfill()
        }

        waitForExpectations(timeout: 1)
    }
    
    
    func test_getLeagues_failure_callsRenderError() {

        let exp = expectation(
            description: "render error"
        )

        mockRepo.leaguesResult =
            .failure(TestError.network)

        presenter.getLeagues(for: .football)

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.1
        ) {

            XCTAssertTrue(
                self.mockView.renderErrorCalled
            )

            XCTAssertEqual(
                self.mockView.receivedErrorMessage,
                "Network Error"
            )

            exp.fulfill()
        }

        waitForExpectations(timeout: 1)
    }
    
}
