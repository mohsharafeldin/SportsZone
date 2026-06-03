//
//  LeaguesRepo.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 23/05/2026.
//

protocol LeaguesRepoProtocol {
    func fetchEvents(
        sport: SportType,
        leagueID: String,
        from: String,
        to: String,
        completion: @escaping (Result<[Event], Error>) -> Void
    )

    func fetchTeams(
        sport: SportType,
        leagueID: String,
        completion: @escaping (Result<[Team], Error>) -> Void
    )
}

class LeaguesRepo: LeaguesRepoProtocol {

    private let network: NetworkManager

    init(network: NetworkManager = .shared) {
        self.network = network
    }

    func fetchEvents(
        sport: SportType,
        leagueID: String,
        from: String,
        to: String,
        completion: @escaping (Result<[Event], any Error>) -> Void
    ) {
        let params: [String: String] = [
            "met": ApiConstants.events,
            "leagueId": leagueID,
            "from": from,
            "to": to,
        ]

        network.request(sport: sport, paremeters: params) {
            (result: Result<EventResponse, Error>) in
            switch result {
            case .success(let data): completion(.success(data.result ?? []))
            case .failure(let error): completion(.failure(error))
            }
        }

    }

    func fetchTeams(
        sport: SportType,
        leagueID: String,
        completion: @escaping (Result<[Team], any Error>) -> Void
    ) {
        let params: [String: String] = [
            "met": ApiConstants.teams,
            "leagueId": leagueID,
        ]

        network.request(sport: sport, paremeters: params) {
            (result: Result<TeamResponse, Error>) in
            switch result {
            case .success(let data): completion(.success(data.result ?? []))
            case .failure(let error): completion(.failure(error))
            }
        }
    }

}
