//
//  File.swift
//  SportsZoneTests
//
//  Created by mohamed sharaf on 05/06/2026.
//

import XCTest
@testable import SportsZone

final class MockFavouriteLeaguesView:
FavouriteLeaguesViewProtocol {

    var renderFavouritesCalled = false

    var showEmptyStateCalled = false

    var hideEmptyStateCalled = false

    var receivedMessage: String?

    func renderFavourites() {

        renderFavouritesCalled = true
    }

    func showEmptyState(message: String) {

        showEmptyStateCalled = true

        receivedMessage = message
    }

    func hideEmptyState() {

        hideEmptyStateCalled = true
    }

    func reset() {

        renderFavouritesCalled = false

        showEmptyStateCalled = false

        hideEmptyStateCalled = false

        receivedMessage = nil
    }
}
