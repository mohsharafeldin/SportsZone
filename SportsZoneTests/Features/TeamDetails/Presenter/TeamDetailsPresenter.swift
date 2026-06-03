//
//  TeamDetailsPresenter.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 03/06/2026.
//

import XCTest

@testable import SportsZone

private enum TestError: LocalizedError {
    case network
    var errorDescription: String? { "Network error occurred" }
}

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

final class TeamDetailsPresenterTests: XCTestCase {

    var presenter: TeamDetailsPresenter!
    var mockView: MockTeamDetailsView!
    var mockRepo: MockTeamsRepo!

    override func setUp() {
        super.setUp()
        mockRepo = MockTeamsRepo()
        mockView = MockTeamDetailsView()
        presenter = TeamDetailsPresenter(repo: mockRepo)
        presenter.view = mockView
    }

    override func tearDown() {
        presenter = nil
        mockView = nil
        mockRepo = nil
        super.tearDown()
    }

    // Initial State

    func test_initialState_teamDataIsNil() {
        XCTAssertNil(presenter.teamData, "teamData")
    }

    // Loading

    func test_loadData_callsShowLoadingImmediately() {
        presenter.loadData(sport: .football, teamID: "1")
        XCTAssertTrue(mockView.showLoadingCalled)
    }

    func test_loadData_success_callsHideLoading() {
        mockRepo.teamDetailsResult = .success([makeTeam()])
        presenter.loadData(sport: .football, teamID: "1")
        XCTAssertTrue(mockView.hideLoadingCalled)
    }

    func test_loadData_failure_callsHideLoading() {
        mockRepo.teamDetailsResult = .failure(TestError.network)
        presenter.loadData(sport: .football, teamID: "1")
        XCTAssertTrue(mockView.hideLoadingCalled)
    }

    func test_loadData_emptyArray_callsHideLoading() {
        mockRepo.teamDetailsResult = .success([])
        presenter.loadData(sport: .football, teamID: "1")
        XCTAssertTrue(mockView.hideLoadingCalled)
    }

    // Data Stored

    func test_loadData_success_storesFirstTeam() {
        let team = makeTeam(key: 99)
        mockRepo.teamDetailsResult = .success([team])
        presenter.loadData(sport: .football, teamID: "1")

        XCTAssertNotNil(presenter.teamData)
        XCTAssertEqual(presenter.teamData?.teamKey, 99)
    }

    func test_loadData_multipleTeams_storesOnlyFirstTeam() {
        let first = makeTeam(key: 1)
        let second = makeTeam(key: 2)
        mockRepo.teamDetailsResult = .success([first, second])
        presenter.loadData(sport: .football, teamID: "1")

        XCTAssertEqual(presenter.teamData?.teamKey, 1, "first team")
    }

    func test_loadData_success_callsLoadDataOnView() {
        mockRepo.teamDetailsResult = .success([makeTeam()])
        presenter.loadData(sport: .football, teamID: "1")

        XCTAssertTrue(mockView.loadDataCalled)
    }

    func test_loadData_success_doesNotShowError() {
        mockRepo.teamDetailsResult = .success([makeTeam()])
        presenter.loadData(sport: .football, teamID: "1")

        XCTAssertFalse(mockView.showErrorCalled)
    }

    func test_loadData_success_teamNameIsPreserved() {
        let json = """
            {
                "team_key": 10,
                "team_name": "Al Ahly",
                "team_logo": "https://example.com/logo.png",
                "players": null,
                "coaches": null
            }
            """
        let team = try! JSONDecoder().decode(
            Team.self,
            from: json.data(using: .utf8)!
        )
        mockRepo.teamDetailsResult = .success([team])
        presenter.loadData(sport: .football, teamID: "10")

        XCTAssertEqual(presenter.teamData?.teamName, "Al Ahly")
    }

    // Empty Array

    func test_loadData_emptyArray_teamDataRemainsNil() {
        mockRepo.teamDetailsResult = .success([])
        presenter.loadData(sport: .football, teamID: "1")

        XCTAssertNil(presenter.teamData, "team data")
    }

    func test_loadData_emptyArray_showsNoTeamDataError() {
        mockRepo.teamDetailsResult = .success([])
        presenter.loadData(sport: .football, teamID: "1")

        XCTAssertTrue(mockView.showErrorCalled)
        XCTAssertEqual(mockView.errorMessages.first, "No team data found")
    }

    func test_loadData_emptyArray_doesNotCallLoadDataOnView() {
        mockRepo.teamDetailsResult = .success([])
        presenter.loadData(sport: .football, teamID: "1")

        XCTAssertFalse(mockView.loadDataCalled)
    }

    // Failure

    func test_loadData_failure_showsError() {
        mockRepo.teamDetailsResult = .failure(TestError.network)
        presenter.loadData(sport: .football, teamID: "1")

        XCTAssertTrue(mockView.showErrorCalled)
        XCTAssertEqual(
            mockView.errorMessages.first,
            TestError.network.localizedDescription
        )
    }

    func test_loadData_failure_teamDataRemainsNil() {
        mockRepo.teamDetailsResult = .failure(TestError.network)
        presenter.loadData(sport: .football, teamID: "1")

        XCTAssertNil(presenter.teamData)
    }

    func test_loadData_failure_doesNotCallLoadDataOnView() {
        mockRepo.teamDetailsResult = .failure(TestError.network)
        presenter.loadData(sport: .football, teamID: "1")

        XCTAssertFalse(mockView.loadDataCalled)
    }

    // Repository Call Verification

    func test_loadData_callsFetchTeamDetailsExactlyOnce() {
        mockRepo.teamDetailsResult = .success([makeTeam()])
        presenter.loadData(sport: .football, teamID: "1")

        XCTAssertEqual(mockRepo.fetchTeamDetailsCallCount, 1)
    }

    func test_loadData_passesSportCorrectly() {
        mockRepo.teamDetailsResult = .success([makeTeam()])
        presenter.loadData(sport: .basketball, teamID: "1")

        XCTAssertEqual(mockRepo.lastSportPassed, .basketball)
    }

    func test_loadData_passesTeamIDCorrectly() {
        mockRepo.teamDetailsResult = .success([makeTeam()])
        presenter.loadData(sport: .football, teamID: "777")

        XCTAssertEqual(mockRepo.lastTeamIDPassed, "777")
    }

    // Edge Cases

    func test_loadData_nilView_doesNotCrash() {
        presenter.view = nil
        mockRepo.teamDetailsResult = .success([makeTeam()])
        XCTAssertNoThrow(presenter.loadData(sport: .football, teamID: "1"))
    }

    func test_loadData_nilView_failure_doesNotCrash() {
        presenter.view = nil
        mockRepo.teamDetailsResult = .failure(TestError.network)
        XCTAssertNoThrow(presenter.loadData(sport: .football, teamID: "1"))
    }

    func test_loadData_calledTwice_teamDataIsOverwritten() {
        let firstTeam = makeTeam(key: 1)
        let secondTeam = makeTeam(key: 2)

        mockRepo.teamDetailsResult = .success([firstTeam])
        presenter.loadData(sport: .football, teamID: "1")
        XCTAssertEqual(presenter.teamData?.teamKey, 1)

        mockRepo.teamDetailsResult = .success([secondTeam])
        presenter.loadData(sport: .football, teamID: "2")
        XCTAssertEqual(
            presenter.teamData?.teamKey,
            2,
            "teamData"
        )
    }
}
