//
//  File.swift
//  SportsZone
//
//  Created by mohamed sharaf on 05/06/2026.
//

import Foundation

protocol HomeViewProtocol: AnyObject {
    func reloadData()
    func showNoInternetAlert()
    func navigateToLeaguesList(with sport: SportType)
}

class HomePresenter {

    weak var view: HomeViewProtocol?

    private let reachability: ReachabilityProtocol

    private let sports: [(name: String, imageName: String)] = [
        ("Cricket", "cricket"),
        ("Basketball", "basketball"),
        ("Tennis", "tennis"),
        ("Football", "football")
    ]

    init(
        view: HomeViewProtocol,
        reachability: ReachabilityProtocol
    ) {
        self.view = view
        self.reachability = reachability
    }

    func viewDidLoad() {
        view?.reloadData()
    }

    func getSportsCount() -> Int {
        sports.count
    }

    func getSport(at index: Int) -> (name: String, imageName: String) {
        sports[index]
    }

    func didSelectSport(at index: Int) {

        guard reachability.isConnected() else {
            view?.showNoInternetAlert()
            return
        }

        let selectedSport = sports[index]

        if let sportType = SportType(rawValue: selectedSport.imageName) {
            view?.navigateToLeaguesList(with: sportType)
        }
    }
}
