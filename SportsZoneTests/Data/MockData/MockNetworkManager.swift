//
//  MockNetworkManager.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 03/06/2026.
//

import XCTest
@testable import SportsZone 

// MARK: - Mock
final class MockNetworkManager: NetworkManagerProtocol {

    var resultToReturn: Any?
    var errorToReturn: Error?

    func request<T: Decodable>(
        sport: SportType,
        paremeters: [String: String] = [:],
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        if let error = errorToReturn {
            completion(.failure(error))
        } else if let result = resultToReturn as? T {
            completion(.success(result))
        }
    }
}
