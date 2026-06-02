//
//  LeaguesPresenter.swift
//  SportsZone
//
//  Created by mohamed sharaf on 01/06/2026.
//


import Foundation

class LeaguesPresenter {
    
    weak var view: LeaguesViewProtocol?
    
    private let repo: LeaguesRepoProtocol
    
    var leagues: [League] = []
    
    var filteredLeagues: [League] = []
    
    init(view: LeaguesViewProtocol,
         repo: LeaguesRepoProtocol = LeaguesRepo()) {
        
        self.view = view
        self.repo = repo
    }
    
    func getLeagues(for sport: SportType) {
        
        repo.fetchLeagues(sport: sport) { [weak self] result in
            
            switch result {
                
            case .success(let data):
                
                self?.leagues = data
                self?.filteredLeagues = data
                
                DispatchQueue.main.async {
                    self?.view?.renderLeagues()
                }
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    self?.view?.renderError(message: error.localizedDescription)
                }
            }
        }
    }
    
    func searchLeague(text: String) {
        
        if text.isEmpty {
            
            filteredLeagues = leagues
            
        } else {
            
            filteredLeagues = leagues.filter {
                
                $0.leagueName?
                    .lowercased()
                    .contains(text.lowercased()) ?? false
            }
        }
        
        view?.renderLeagues()
    }
}
