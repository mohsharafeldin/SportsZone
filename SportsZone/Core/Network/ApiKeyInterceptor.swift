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
        let key = "758cfab54ef5ea8ee215ff739e2b1c5ddb7a249de9d1c4b60cb55cd61a9838af"
        //let key = "945e5f0060ec476ef6fa117d6c191df272cc4596851725669d0c629e7af6ebc2"
            
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
