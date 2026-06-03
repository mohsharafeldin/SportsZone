//
//  FavouriteLeaguesViewController.swift
//  SportsZone
//
//  Created by mohamed sharaf on 23/05/2026.
//

import UIKit

class FavouriteLeaguesViewController: UIViewController {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    

    
    var favourites: [FavouriteLeague] = []
    
    var filteredFavourites: [FavouriteLeague] = []
    
    let searchController =
    UISearchController(searchResultsController: nil)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Favourite Leagues"
        
        setupTableView()
        
        setupSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadFavourites()
    }
}



extension FavouriteLeaguesViewController {
    
    func setupTableView() {
        
        let nib = UINib(
            nibName: "FavouriteLeagueCell",
            bundle: nil
        )
        
        tableView.register(
            nib,
            forCellReuseIdentifier: "cell"
        )
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.rowHeight = 150
        
        tableView.separatorStyle = .none
    }
    
    func setupSearchController() {
        
        navigationItem.searchController =
        searchController
        
        searchController.searchBar.delegate = self
        
        searchController.obscuresBackgroundDuringPresentation =
        false
        
        searchController.searchBar.placeholder =
        "Search Favourite League"
    }
    
    func loadFavourites() {
        
        favourites =
        FavouriteManager.shared.fetchFavourites()
        
        filteredFavourites = favourites
        
        tableView.reloadData()
    }
}

//TableView

extension FavouriteLeaguesViewController:
UITableViewDelegate,
UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        
        return filteredFavourites.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        ) as! FavouriteLeagueCell
        
        let fav =
        filteredFavourites[indexPath.row]
 
        
        cell.leagueName.text =
        fav.leagueName
        
        cell.countryName.text =
        fav.countryName
        
 
        
        if let data = fav.leagueLogo {
            
            cell.leagueImage.image =
            UIImage(data: data)
            
        } else {
            
            cell.leagueImage.image =
            UIImage(named: "placeholder")
        }
        
        // Country Image
        
        if let data = fav.countryLogo {
            
            cell.countryImage.image =
            UIImage(data: data)
            
        } else {
            
            cell.countryImage.image =
            UIImage(named: "placeholder")
        }
        
        //  UI
        
        cell.leagueImage.layer.cornerRadius =
        cell.leagueImage.frame.width / 2
        cell.leagueImage.clipsToBounds = true
        
        cell.countryImage.layer.cornerRadius =
        cell.countryImage.frame.width / 2
        
        cell.countryImage.clipsToBounds = true
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    //  Delete
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt
        indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Delete"
        ) { [weak self] _, _, completion in
            
            guard let self = self else {
                completion(false)
                return
            }
            
            let league =
            self.filteredFavourites[indexPath.row]
            
            FavouriteManager.shared.deleteLeague(
                id: league.leagueID
            )
            
            self.loadFavourites()
            
            completion(true)
        }
        
        return UISwipeActionsConfiguration(
            actions: [deleteAction]
        )
    }
    
    //  Select
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        
        tableView.deselectRow(
            at: indexPath,
            animated: true
        )
        
        let league =
        filteredFavourites[indexPath.row]
        
        // OFFLINE MODE:
        // favourites are local so screen can open
        
        let storyboard = UIStoryboard(
            name: "Main",
            bundle: nil
        )
        
        let detailsVC =
        storyboard.instantiateViewController(
            withIdentifier:
                "LeagueDetailsViewController"
        )
        
        // Pass Data Here Later
        
        navigationController?.pushViewController(
            detailsVC,
            animated: true
        )
    }
}

// Search

extension FavouriteLeaguesViewController:
UISearchBarDelegate {
    
    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {
        
        if searchText.isEmpty {
            
            filteredFavourites = favourites
            
        } else {
            
            filteredFavourites =
            favourites.filter {
                
                $0.leagueName?
                    .lowercased()
                    .contains(
                        searchText.lowercased()
                    ) ?? false
            }
        }
        
        tableView.reloadData()
    }
}

