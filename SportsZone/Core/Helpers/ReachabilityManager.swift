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
    
    let reachability = try! Reachability()
    
    func isConnected() -> Bool {
        
        return reachability.connection != .unavailable
    }
}
