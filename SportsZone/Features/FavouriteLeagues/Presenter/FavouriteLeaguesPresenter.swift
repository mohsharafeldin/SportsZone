//
//  File.swift
//  SportsZone
//
//  Created by mohamed sharaf on 03/06/2026.
//

import Foundation

protocol FavouriteLeaguesViewProtocol: AnyObject {
    
    func renderFavourites()
    
    func showEmptyState(message: String)
    
    func hideEmptyState()
}

class FavouriteLeaguesPresenter {
    
    weak var view: FavouriteLeaguesViewProtocol?
    
    private let favouriteManager = FavouriteManager.shared
    
    var favourites: [FavouriteLeague] = []
    
    var filteredLeagues: [FavouriteLeague] = []
    
    init(view: FavouriteLeaguesViewProtocol) {
        
        self.view = view
    }
    
    // MARK: - Load
    
    func loadFavourites() {
        
        favourites = favouriteManager.fetchFavourites()
        
        filteredLeagues = favourites
        
        updateView()
    }
    
    // MARK: - Delete
    
    func deleteLeague(at indexPath: IndexPath) {
        
        let league = filteredLeagues[indexPath.row]
        
        favouriteManager.deleteLeague(
            id: league.leagueID
        )
        
        loadFavourites()
    }
    
    // MARK: - Search
    
    func search(text: String) {
        
        if text.isEmpty {
            
            filteredLeagues = favourites
            
        } else {
            
            filteredLeagues = favourites.filter {
                
                $0.leagueName?
                    .lowercased()
                    .contains(text.lowercased()) ?? false
            }
        }
        
        updateView()
    }
    
    // MARK: - Private
    
    private func updateView() {
        
        if filteredLeagues.isEmpty {
            
            if favourites.isEmpty {
                
                view?.showEmptyState(
                    message: "No favourite leagues yet ❤️"
                )
                
            } else {
                
                view?.showEmptyState(
                    message: "No leagues found 🔍"
                )
            }
        } else {
            
            view?.hideEmptyState()
        }
        
        view?.renderFavourites()
    }
}

