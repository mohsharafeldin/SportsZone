//
//  File.swift
//  SportsZone
//
//  Created by mohamed sharaf on 01/06/2026.
//

import Foundation
import Reachability

class ReachabilityManager {

    static let shared = ReachabilityManager()

    private init() {}

    func isConnected() -> Bool {
        let reachability = try? Reachability()
        return reachability?.connection != .unavailable
    }
}
