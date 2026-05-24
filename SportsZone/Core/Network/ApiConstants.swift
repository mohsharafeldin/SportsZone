//
//  ApiConstants.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 21/05/2026.
//

enum ApiConstants{
    static let events = "Fixtures"
    static let teams = "Teams"
}

enum SportType: String, CaseIterable{
    case football = "football"
    case basketball = "basketball"
    case cricket = "cricket"
    case tennis = "tennis"
    
    var baseUrl: String{
        return "https://apiv2.allsportsapi.com/\(self.rawValue)/"
    }
    
    var displayName: String{
        switch self{
            case .football: return "Football"
            case .basketball: return "Basketball"
            case .cricket: return "Cricket"
            case .tennis: return "Tennis"
        }
    }
    
    var icon: String{
        switch self{
            case .football: return "soccerball"
            case .basketball: return "basketball"
            case .cricket: return "cricket.ball"
            case .tennis: return "tennis.racket"
        }
    }
}
