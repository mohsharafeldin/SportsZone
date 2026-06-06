//
//MockLeaguesView.swift
//  SportsZoneTests
//
//  Created by mohamed sharaf on 04/06/2026.
//



import XCTest
@testable import SportsZone

final class MockLeaguesView: LeaguesViewProtocol {

    var renderLeaguesCalled = false

    var renderErrorCalled = false

    var receivedErrorMessage: String?

    func renderLeagues() {

        renderLeaguesCalled = true
    }

    func renderError(message: String) {

        renderErrorCalled = true

        receivedErrorMessage = message
    }

    func reset() {

        renderLeaguesCalled = false

        renderErrorCalled = false

        receivedErrorMessage = nil
    }
}

