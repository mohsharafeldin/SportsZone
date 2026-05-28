//
//  TeamsRepo.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 24/05/2026.
//

protocol TeamsRepoProtocol {
    func fetchTeamDetails(
        sport: SportType,
        teamID: String,
        completion: @escaping (Result<[Team], Error>) -> Void
    )
}

class TeamsRepo: TeamsRepoProtocol {

    private let newtwork: NetworkManager

    init(newtwork: NetworkManager = .shared) {
        self.newtwork = newtwork
    }

    func fetchTeamDetails(
        sport: SportType,
        teamID: String,
        completion: @escaping (Result<[Team], any Error>) -> Void
    ) {
        let params: [String: String] = [
            "met": ApiConstants.teams,
            "teamId": teamID,
        ]

        newtwork.request(sport: sport, paremeters: params) {
            (result: Result<TeamResponse, Error>) in
            switch result {
            case .success(let data): completion(.success(data.result))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}
