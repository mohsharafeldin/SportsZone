//
//  Fileb.swift
//  SportsZone
//
//  Created by mohamed sharaf on 02/06/2026.
//

import Foundation

import UIKit
import CoreData

class FavouriteManager {
    
    static let shared = FavouriteManager()
    
    let context = CoreDataManager.shared.context
    
    func saveLeague(
        league: League,
        leagueImage: Data?,
        countryImage: Data?
    ) {
        
        let leagueID =
        Int64(league.leagueKey ?? 0)
        
        // Prevent duplicates
        
        if isFavourite(id: leagueID) {
            return
        }
        
        let fav = FavouriteLeague(
            context: context
        )
        
        fav.leagueID = leagueID
        
        fav.leagueName =
        league.leagueName
        
        fav.countryName =
        league.countryName
        
        fav.leagueLogo =
        leagueImage
        
        fav.countryLogo =
        countryImage
        
        do {
            
            try context.save()
            
        } catch {
            
            print(error.localizedDescription)
        }
    }

    
    func fetchFavourites() -> [FavouriteLeague] {
        
        let request: NSFetchRequest<FavouriteLeague>
        = FavouriteLeague.fetchRequest()
        
        return (try? context.fetch(request)) ?? []
    }
    
    func deleteLeague(id: Int64) {
        
        let request:
        NSFetchRequest<FavouriteLeague>
        = FavouriteLeague.fetchRequest()
        
        request.predicate =
        NSPredicate(
            format: "leagueID == %d",
            id
        )
        
        do {
            
            let results =
            try context.fetch(request)
            
            for item in results {
                context.delete(item)
            }
            
            try context.save()
            
        } catch {
            
            print(error.localizedDescription)
        }
    }

    
    func isFavourite(id: Int64) -> Bool {
        
        let request: NSFetchRequest<FavouriteLeague>
        = FavouriteLeague.fetchRequest()
        
        request.predicate =
        NSPredicate(format: "leagueID == %d", id)
        
        do {
            
            let count = try context.count(for: request)
            
            return count > 0
            
        } catch {
            
            print(error.localizedDescription)
            
            return false
        }
    }

}
