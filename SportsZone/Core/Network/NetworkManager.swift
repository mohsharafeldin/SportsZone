//
//  NetworkManager.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 21/05/2026.
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol {
    func request<T: Decodable>(
        sport: SportType,
        paremeters: [String: String],
        completion: @escaping (Result<T, Error>) -> Void
    )
}

class NetworkManager : NetworkManagerProtocol{
    
    static let shared = NetworkManager()
    private let session: Session
    
    private init(){
        session = Session(interceptor: ApiKeyInterceptor())
    }
    
    func request <T:Decodable> (
        sport: SportType,
        paremeters: [String:String] = [:],
        completion: @escaping (Result<T, Error>) -> Void
    ){
        session.request(sport.baseUrl, parameters: paremeters)
            .validate()
            .responseDecodable(of: T.self){ response in
                switch response.result{
                case .success(let data): completion(.success(data))
                case .failure(let error): completion(.failure(error))
                }
            }
    }
}
