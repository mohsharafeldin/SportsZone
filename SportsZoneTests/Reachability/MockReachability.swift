//
//  File.swift
//  SportsZoneTests
//
//  Created by mohamed sharaf on 04/06/2026.
//


import Foundation
@testable import SportsZone

final class MockReachability: ReachabilityProtocol {

    var connected = true

    func isConnected() -> Bool {
        connected
    }

    func reset() {
        connected = true
    }
}
