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
        completion: @escaping (Result<[any SportEvent], Error>) -> Void
    )

    func fetchTeams(
        sport: SportType,
        leagueID: String,
        completion: @escaping (Result<[Team], Error>) -> Void
    )

    func fetchTennisPlayers(
        leagueID: String,
        completion: @escaping (Result<[TennisPlayer], Error>) -> Void
    )
    
    func fetchLeagues(
        sport: SportType,
        completion: @escaping (Result<[League], Error>) -> Void
    )
}

class LeaguesRepo: LeaguesRepoProtocol {

    private let network: NetworkManagerProtocol

    init(network: NetworkManagerProtocol = NetworkManager.shared) {
        self.network = network
    }

    func fetchEvents(
            sport: SportType,
            leagueID: String,
            from: String,
            to: String,
            completion: @escaping (Result<[any SportEvent], Error>) -> Void
        ) {
            let params: [String: String] = [
                "met": ApiConstants.events,
                "leagueId": leagueID,
                "from": from,
                "to": to,
            ]
            print ("req is: sports type: \(sport) params: \(params)")
            
            switch sport {
            case .football:
                fetchTyped(FootballEvent.self, sport: sport, params: params, completion: completion)
            case .basketball:
                fetchTyped(BasketballEvent.self, sport: sport, params: params, completion: completion)
            case .cricket:
                fetchTyped(CricketEvent.self, sport: sport, params: params, completion: completion)
            case .tennis:
                fetchTyped(TennisEvent.self, sport: sport, params: params, completion: completion)
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
    
    func fetchTennisPlayers(
        leagueID: String,
        completion: @escaping (Result<[TennisPlayer], Error>) -> Void
    ) {
        let params: [String: String] = [
            "met": ApiConstants.players,
            "leagueId": leagueID,
        ]

        network.request(sport: .tennis, paremeters: params) {
            (result: Result<TennisPlayersResponse, Error>) in
            switch result {
            case .success(let data):
                completion(.success(data.result ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchLeagues(
        sport: SportType,
        completion: @escaping (Result<[League], Error>) -> Void
    ) {
        
        let params: [String:String] = [
            "met" : ApiConstants.leagues
        ]
        
        network.request(sport: sport, paremeters: params) {
            (result: Result<LeagueResponse, Error>) in
            
            switch result {
                
            case .success(let data):
                completion(.success(data.result))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func fetchTyped<T: Decodable & SportEvent>(
        _ type: T.Type,
        sport: SportType,
        params: [String: String],
        completion: @escaping (Result<[any SportEvent], Error>) -> Void
    ) {
        network.request(sport: sport, paremeters: params) {
            (result: Result<SportEventResponse<T>, Error>) in
            switch result {
            case .success(let data):
                let events: [any SportEvent] = data.result ?? []
                completion(.success(events))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
