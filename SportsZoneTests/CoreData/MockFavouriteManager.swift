//
//  File.swift
//  SportsZoneTests
//
//  Created by mohamed sharaf on 04/06/2026.
//

import XCTest
@testable import SportsZone

final class MockFavouriteManager: FavouriteManagerProtocol {

    var favourites: [FavouriteLeague] = []

    var fetchFavouritesCalled = false

    var deleteLeagueCalled = false

    var deletedLeagueID: Int64?

    func fetchFavourites() -> [FavouriteLeague] {

        fetchFavouritesCalled = true

        return favourites
    }

    func deleteLeague(id: Int64) {

        deleteLeagueCalled = true

        deletedLeagueID = id
    }

    func reset() {

        favourites = []

        fetchFavouritesCalled = false

        deleteLeagueCalled = false

        deletedLeagueID = nil
    }
}
