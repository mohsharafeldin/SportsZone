//
//  MockTeamDetailsView.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 03/06/2026.
//

import XCTest

@testable import SportsZone

// MARK: - Mock View
 
final class MockTeamDetailsView: TeamDetailsViewProtocol {
    var showLoadingCalled = false
    var hideLoadingCalled = false
    var loadDataCalled    = false
    var showErrorCalled   = false
    var errorMessages: [String] = []
 
    func showLoading()  { showLoadingCalled = true }
    func hideLoading()  { hideLoadingCalled = true }
    func loadData()     { loadDataCalled    = true }
    func showError(_ message: String) {
        showErrorCalled = true
        errorMessages.append(message)
    }
 
    func reset() {
        showLoadingCalled = false
        hideLoadingCalled = false
        loadDataCalled    = false
        showErrorCalled   = false
        errorMessages     = []
    }
}
