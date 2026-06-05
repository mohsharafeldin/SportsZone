//
//  File.swift
//  SportsZone
//
//  Created by mohamed sharaf on 05/06/2026.
//

protocol HomeViewProtocol: AnyObject {
    func reloadData()
    func showNoInternetAlert()
    func navigateToLeaguesList(with sport: SportType)
}


class HomePresenter {
    
    weak var view: HomeViewProtocol?
    
    private let sports: [(name: String, imageName: String)] = [
        ("Cricket", "cricket"),
        ("Basketball", "basketball"),
        ("Tennis", "tennis"),
        ("Football", "football")
    ]
    
    init(view: HomeViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        view?.reloadData()
    }
    
    
    func getSportsCount() -> Int {
        return sports.count
    }
    
    func getSport(at index: Int) -> (name: String, imageName: String) {
        return sports[index]
    }
    
    
    func didSelectSport(at index: Int) {
        guard ReachabilityManager.shared.isConnected() else {
            view?.showNoInternetAlert()
            return
        }
        
        let selectedSport = sports[index]
        
        if let sportType = SportType(rawValue: selectedSport.imageName) {
            view?.navigateToLeaguesList(with: sportType)
        }
    }
}
