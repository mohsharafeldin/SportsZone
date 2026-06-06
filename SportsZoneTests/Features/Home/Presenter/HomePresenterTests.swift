//
//  HomePresenterTests.swift
//  SportsZoneTests
//
//  Created by mohamed sharaf on 06/06/2026.
//


import XCTest
@testable import SportsZone

final class HomePresenterTests: XCTestCase {

    var presenter: HomePresenter!
    var mockView: MockHomeView!
    var mockReachability: MockReachability!

    override func setUp() {
        super.setUp()

        mockView = MockHomeView()
        mockReachability = MockReachability()

        presenter = HomePresenter(
            view: mockView,
            reachability: mockReachability
        )
    }

    override func tearDown() {

        presenter = nil
        mockView = nil
        mockReachability = nil

        super.tearDown()
    }

    // MARK: Initial State

    func test_getSportsCount_returnsFour() {

        XCTAssertEqual(
            presenter.getSportsCount(),
            4
        )
    }

    // MARK: View Did Load

    func test_viewDidLoad_callsReloadData() {

        presenter.viewDidLoad()

        XCTAssertTrue(
            mockView.reloadDataCalled
        )
    }

    // MARK: Sport Data

    func test_getSportAtZero_returnsCricket() {

        let sport =
        presenter.getSport(at: 0)

        XCTAssertEqual(
            sport.name,
            "Cricket"
        )

        XCTAssertEqual(
            sport.imageName,
            "cricket"
        )
    }

    func test_getSportAtOne_returnsBasketball() {

        let sport =
        presenter.getSport(at: 1)

        XCTAssertEqual(
            sport.name,
            "Basketball"
        )

        XCTAssertEqual(
            sport.imageName,
            "basketball"
        )
    }

    func test_getSportAtTwo_returnsTennis() {

        let sport =
        presenter.getSport(at: 2)

        XCTAssertEqual(
            sport.name,
            "Tennis"
        )

        XCTAssertEqual(
            sport.imageName,
            "tennis"
        )
    }

    func test_getSportAtThree_returnsFootball() {

        let sport =
        presenter.getSport(at: 3)

        XCTAssertEqual(
            sport.name,
            "Football"
        )

        XCTAssertEqual(
            sport.imageName,
            "football"
        )
    }

    // MARK: No Internet

    func test_didSelectSport_withoutInternet_showsAlert() {

        mockReachability.connected = false

        presenter.didSelectSport(at: 0)

        XCTAssertTrue(
            mockView.showNoInternetAlertCalled
        )

        XCTAssertFalse(
            mockView.navigateToLeaguesListCalled
        )
    }

    // MARK: Navigation

    func test_didSelectSport_cricket_navigates() {

        presenter.didSelectSport(at: 0)

        XCTAssertTrue(
            mockView.navigateToLeaguesListCalled
        )

        XCTAssertEqual(
            mockView.receivedSport,
            .cricket
        )
    }

    func test_didSelectSport_basketball_navigates() {

        presenter.didSelectSport(at: 1)

        XCTAssertEqual(
            mockView.receivedSport,
            .basketball
        )
    }

    func test_didSelectSport_tennis_navigates() {

        presenter.didSelectSport(at: 2)

        XCTAssertEqual(
            mockView.receivedSport,
            .tennis
        )
    }

    func test_didSelectSport_football_navigates() {

        presenter.didSelectSport(at: 3)

        XCTAssertEqual(
            mockView.receivedSport,
            .football
        )
    }

    // MARK: Nil View

    func test_viewDidLoad_nilView_doesNotCrash() {

        presenter.view = nil

        XCTAssertNoThrow(
            presenter.viewDidLoad()
        )
    }

    func test_didSelectSport_nilView_doesNotCrash() {

        presenter.view = nil

        XCTAssertNoThrow(
            presenter.didSelectSport(at: 0)
        )
    }
}
