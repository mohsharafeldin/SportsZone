//
//  ApiKeyManager.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 21/05/2026.
//

import Foundation
import Alamofire

class ApiKeyInterceptor : RequestInterceptor{
    
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        
        var request = urlRequest
        let key = "ab876a640563e8cd3a2254e9e522cd8dbde56213bdc0e68d92274a1a945b4c55"
            
        if let url = request.url,
           var components = URLComponents(url: url, resolvingAgainstBaseURL: false){
            
            var queryItems = components.queryItems
            
            if !queryItems!.contains(where: { $0.name == "APIkey" }){
                queryItems?.append(URLQueryItem(name: "APIkey", value: key))
            }
            
            components.queryItems = queryItems
            request.url = components.url
        }
            
            completion(.success(request))
    }
}
