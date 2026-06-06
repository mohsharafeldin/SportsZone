//
//  LeaguesDetailsPresenter.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 23/05/2026.
//

import Foundation

protocol LeaguesDetailsViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func reloadData()
    func showError(_ message: String)
}

class LeaguesDetailsPresenter {
    weak var view: LeaguesDetailsViewProtocol?
    private let repo: LeaguesRepoProtocol

    private(set) var upcomingEvents: [SportEvent] = []
    private(set) var latestEvents: [SportEvent]   = []
    private(set) var teams: [Team] = []
    private(set) var tennisPlayers: [TennisPlayer] = []
    private(set) var isLoading = false

    init(repository: LeaguesRepoProtocol = LeaguesRepo()) {
        self.repo = repository
    }

    func loadData(sport: SportType, leagueID: String, from: String, to: String)
    {
        isLoading = true
        view?.showLoading()

        let group = DispatchGroup()

        group.enter()
        repo.fetchEvents(sport: sport, leagueID: leagueID, from: from, to: to) {
            [weak self] result in

            defer { group.leave() }
            switch result {

            case .success(let data):                
                let today = Date()
                self?.upcomingEvents = data.filter { $0.eventDate >= formattedDate(today) }
                self?.latestEvents   = data.filter { $0.eventDate < formattedDate(today) }
                print("UpComing Events Count = \(self?.upcomingEvents.count)")
                print("Latest Events Count = \(self?.latestEvents.count)")

            case .failure(let error):
                self?.view?.showError(error.localizedDescription)
            }
        }

        group.enter()
        if sport == .tennis{
            repo.fetchTennisPlayers(leagueID: leagueID) {
                [weak self] result in

                defer { group.leave() }
                switch result {

                case .success(let data):
                    print("Teams Count = \(data.count)")
                    self?.tennisPlayers = data

                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }else{
            repo.fetchTeams(sport: sport, leagueID: leagueID) {
                [weak self] result in

                defer { group.leave() }
                switch result {

                case .success(let data):
                    print("Teams Count = \(data.count)")
                    self?.teams = data

                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }

        group.notify(queue: .main) {
            [weak self] in
            
            guard let self = self else { return }
            
            self.isLoading = false
            self.view?.hideLoading()
            self.view?.reloadData()
        }
    }
}
