//
//  TeamDetailsPresenter.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 24/05/2026.
//

protocol TeamDetailsViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func loadData()
    func showError(_ message: String)
}

class TeamDetailsPresenter {
    weak var view: TeamDetailsViewProtocol?
    private let repo: TeamsRepoProtocol

    var teamData: Team?

    init(repo: TeamsRepoProtocol = TeamsRepo()) {
        self.repo = repo
    }

    func loadData(sport: SportType, teamID: String) {
        view?.showLoading()

        repo.fetchTeamDetails(sport: sport, teamID: teamID) {
            [weak self] result in

            guard let self else { return }

            switch result {
            case .success(let data):
                guard let firstTeam = data.first else {
                    self.view?.hideLoading()
                    self.view?.showError("No team data found")
                    return
                }

                self.teamData = firstTeam

                self.view?.hideLoading()
                self.view?.loadData()

            case .failure(let error):
                self.view?.hideLoading()
                self.view?.showError(error.localizedDescription)
            }
        }
    }
}
