//
//  FavouriteLeaguesPresenterTests.swift
//  SportsZoneTests
//
//  Created by mohamed sharaf on 04/06/2026.
//


//  FavouriteLeaguesPresenterTests.swift


import XCTest
import CoreData

@testable import SportsZone

final class FavouriteLeaguesPresenterTests: XCTestCase {

    var presenter: FavouriteLeaguesPresenter!

    var mockView: MockFavouriteLeaguesView!

    var mockManager: MockFavouriteManager!

    override func setUp() {
        super.setUp()

        mockView = MockFavouriteLeaguesView()

        mockManager = MockFavouriteManager()

        presenter = FavouriteLeaguesPresenter(
            view: mockView,
            favouriteManager: mockManager
        )
    }

    override func tearDown() {

        presenter = nil

        mockView = nil

        mockManager = nil

        super.tearDown()
    }
    

    // MARK: - Helper

    private func makeFavouriteLeague(
        id: Int64 = 1,
        name: String = "Premier League"
    ) -> FavouriteLeague {

        let entity =
        NSEntityDescription.entity(
            forEntityName: "FavouriteLeague",
            in: CoreDataManager.shared.context
        )!

        let league = FavouriteLeague(
            entity: entity,
            insertInto: nil
        )

        league.leagueID = id
        league.leagueName = name
        league.countryName = "England"

        return league
    }

    // MARK: - Initial State

    func test_initialState_favouritesEmpty() {

        XCTAssertTrue(
            presenter.favourites.isEmpty
        )
    }

    func test_initialState_filteredLeaguesEmpty() {

        XCTAssertTrue(
            presenter.filteredLeagues.isEmpty
        )
    }

    // MARK: - Load Favourites

    func test_loadFavourites_callsFetchFavourites() {

        presenter.loadFavourites()

        XCTAssertTrue(
            mockManager.fetchFavouritesCalled
        )
    }

    func test_loadFavourites_updatesFavourites() {

        let league =
        makeFavouriteLeague()

        mockManager.favourites = [league]

        presenter.loadFavourites()

        XCTAssertEqual(
            presenter.favourites.count,
            1
        )
    }

    func test_loadFavourites_updatesFilteredLeagues() {

        let league =
        makeFavouriteLeague()

        mockManager.favourites = [league]

        presenter.loadFavourites()

        XCTAssertEqual(
            presenter.filteredLeagues.count,
            1
        )
    }

    func test_loadFavourites_emptyList_showsEmptyState() {

        mockManager.favourites = []

        presenter.loadFavourites()

        XCTAssertTrue(
            mockView.showEmptyStateCalled
        )

        XCTAssertEqual(
            mockView.receivedMessage,
            "No favourite leagues yet ❤️"
        )
    }

    func test_loadFavourites_emptyList_rendersView() {

        mockManager.favourites = []

        presenter.loadFavourites()

        XCTAssertTrue(
            mockView.renderFavouritesCalled
        )
    }

    func test_loadFavourites_nonEmpty_hidesEmptyState() {

        mockManager.favourites = [
            makeFavouriteLeague()
        ]

        presenter.loadFavourites()

        XCTAssertTrue(
            mockView.hideEmptyStateCalled
        )
    }

    func test_loadFavourites_nonEmpty_rendersView() {

        mockManager.favourites = [
            makeFavouriteLeague()
        ]

        presenter.loadFavourites()

        XCTAssertTrue(
            mockView.renderFavouritesCalled
        )
    }

    // MARK: - Search

    func test_search_emptyText_returnsAllLeagues() {

        presenter.favourites = [
            makeFavouriteLeague(
                id: 1,
                name: "Premier League"
            ),
            makeFavouriteLeague(
                id: 2,
                name: "La Liga"
            )
        ]

        presenter.search(text: "")

        XCTAssertEqual(
            presenter.filteredLeagues.count,
            2
        )
    }

    func test_search_existingLeague_filtersCorrectly() {

        presenter.favourites = [
            makeFavouriteLeague(
                id: 1,
                name: "Premier League"
            ),
            makeFavouriteLeague(
                id: 2,
                name: "La Liga"
            )
        ]

        presenter.search(text: "premier")

        XCTAssertEqual(
            presenter.filteredLeagues.count,
            1
        )

        XCTAssertEqual(
            presenter.filteredLeagues.first?.leagueName,
            "Premier League"
        )
    }

    func test_search_caseInsensitive() {

        presenter.favourites = [
            makeFavouriteLeague(
                name: "Premier League"
            )
        ]

        presenter.search(text: "PREMIER")

        XCTAssertEqual(
            presenter.filteredLeagues.count,
            1
        )
    }

    func test_search_noMatches_returnsEmptyArray() {

        presenter.favourites = [
            makeFavouriteLeague(
                name: "Premier League"
            )
        ]

        presenter.search(text: "Egypt")

        XCTAssertTrue(
            presenter.filteredLeagues.isEmpty
        )
    }

    func test_search_noMatches_showsNoLeaguesFoundMessage() {

        presenter.favourites = [
            makeFavouriteLeague(
                name: "Premier League"
            )
        ]

        presenter.search(text: "Egypt")

        XCTAssertTrue(
            mockView.showEmptyStateCalled
        )

        XCTAssertEqual(
            mockView.receivedMessage,
            "No leagues found 🔍"
        )
    }

    func test_search_callsRenderFavourites() {

        presenter.favourites = [
            makeFavouriteLeague()
        ]

        presenter.search(text: "")

        XCTAssertTrue(
            mockView.renderFavouritesCalled
        )
    }

    func test_search_nonEmptyResult_hidesEmptyState() {

        presenter.favourites = [
            makeFavouriteLeague(
                name: "Premier League"
            )
        ]

        presenter.search(text: "premier")

        XCTAssertTrue(
            mockView.hideEmptyStateCalled
        )
    }

    // MARK: - Delete

    func test_deleteLeague_callsDeleteLeague() {

        let league =
        makeFavouriteLeague(id: 99)

        presenter.filteredLeagues = [league]

        presenter.deleteLeague(
            at: IndexPath(
                row: 0,
                section: 0
            )
        )

        XCTAssertTrue(
            mockManager.deleteLeagueCalled
        )

        XCTAssertEqual(
            mockManager.deletedLeagueID,
            99
        )
    }

    func test_deleteLeague_reloadsData() {

        let league =
        makeFavouriteLeague()

        presenter.filteredLeagues = [league]

        presenter.deleteLeague(
            at: IndexPath(
                row: 0,
                section: 0
            )
        )

        XCTAssertTrue(
            mockManager.fetchFavouritesCalled
        )
    }

    // MARK: - Nil View

    func test_loadFavourites_nilView_doesNotCrash() {

        presenter.view = nil

        XCTAssertNoThrow(
            presenter.loadFavourites()
        )
    }

    func test_search_nilView_doesNotCrash() {

        presenter.view = nil

        XCTAssertNoThrow(
            presenter.search(text: "")
        )
    }

    func test_deleteLeague_nilView_doesNotCrash() {

        presenter.view = nil

        presenter.filteredLeagues = [
            makeFavouriteLeague()
        ]

        XCTAssertNoThrow(
            presenter.deleteLeague(
                at: IndexPath(
                    row: 0,
                    section: 0
                )
            )
        )
    }
    
    func test_deleteLeague_updatesViewAfterDeletion() {

        let league =
        makeFavouriteLeague(
            id: 1,
            name: "Premier League"
        )

        presenter.filteredLeagues = [league]

        presenter.deleteLeague(
            at: IndexPath(
                row: 0,
                section: 0
            )
        )

        XCTAssertTrue(
            mockView.renderFavouritesCalled
        )
    }
    func test_search_nilLeagueName_returnsEmptyArray() {

        let league =
        makeFavouriteLeague()

        league.leagueName = nil

        presenter.favourites = [league]

        presenter.search(text: "Premier")

        XCTAssertTrue(
            presenter.filteredLeagues.isEmpty
        )
    }
}
