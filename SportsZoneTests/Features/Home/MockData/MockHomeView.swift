//
//  File.swift
//  SportsZoneTests
//
//  Created by mohamed sharaf on 04/06/2026.
//



import XCTest
@testable import SportsZone

final class MockHomeView: HomeViewProtocol {

    var reloadDataCalled = false

    var showNoInternetAlertCalled = false

    var navigateToLeaguesListCalled = false

    var receivedSport: SportType?

    func reloadData() {
        reloadDataCalled = true
    }

    func showNoInternetAlert() {
        showNoInternetAlertCalled = true
    }

    func navigateToLeaguesList(with sport: SportType) {
        navigateToLeaguesListCalled = true
        receivedSport = sport
    }

    func reset() {
        reloadDataCalled = false
        showNoInternetAlertCalled = false
        navigateToLeaguesListCalled = false
        receivedSport = nil
    }
}
