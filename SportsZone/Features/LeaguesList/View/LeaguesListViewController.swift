//
//  LeaguesListViewController.swift
//  SportsZone
//
//  Created by mohamed sharaf on 23/05/2026.
//

import UIKit
import SDWebImage

class LeaguesListViewController: UIViewController {
    

    
    @IBOutlet weak var tableView: UITableView!
    

    
    var selectedSport: SportType?
    
    var presenter: LeaguesPresenter!
    
    let searchController =
    UISearchController(searchResultsController: nil)
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Leagues"
        
        presenter = LeaguesPresenter(view: self)
        
        setupTableView()
        
        setupSearchController()
        
        if let sport = selectedSport {
            
            showLoadingIndecator()
            
            presenter.getLeagues(for: sport)
        }
    }
}



extension LeaguesListViewController {
    
    func setupTableView() {
        
        let nib = UINib(
            nibName: "LeagueCell",
            bundle: nil
        )
        
        tableView.register(
            nib,
            forCellReuseIdentifier: "cell"
        )
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.rowHeight = 170
    }
    
    func setupSearchController() {
        
        navigationItem.searchController =
        searchController
        
        searchController.searchBar.delegate = self
        
        searchController.obscuresBackgroundDuringPresentation =
        false
        
        searchController.searchBar.placeholder =
        "Search League"
    }
}

//  TableView

extension LeaguesListViewController:
UITableViewDelegate,
UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        
        return presenter?.filteredLeagues.count ?? 0
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        ) as! LeagueCell
        
        let league =
        presenter.filteredLeagues[indexPath.row]
        
        
        cell.delegate = self
        
        
        cell.leagueName.text =
        league.leagueName
        
        cell.countryName.text =
        league.countryName
        
        //  League Image
        
        cell.leagueImage.sd_setImage(
            with: URL(
                string: league.leagueLogo ?? ""
            ),
            placeholderImage:
                UIImage(named: "logo")
        )
        
        //  Country Image
        
        cell.countryImage.sd_setImage(
            with: URL(
                string: league.countryLogo ?? ""
            ),
            placeholderImage:
                UIImage(named: "logo")
        )
        
        //  UI
        
        cell.leagueImage.layer.cornerRadius =
        cell.leagueImage.frame.width / 2
        
        cell.leagueImage.clipsToBounds = true
        cell.countryImage.layer.cornerRadius =
        cell.countryImage.frame.width / 2
        
        cell.countryImage.clipsToBounds = true
        
        // making faviurite buttun collered
        let isFavourite =
        FavouriteManager.shared.isFavourite(
            id: Int64(league.leagueKey ?? 0)
        )

        let imageName =
        isFavourite ? "heart.fill" : "heart"

        cell.favouriteButton.setImage(
            UIImage(systemName: imageName),
            for: .normal
        )

        cell.favouriteButton.tintColor =
        isFavourite ? .systemRed : .lightGray
        
        
        return cell
    }
    
    // Select Row
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        
        if ReachabilityManager.shared.isConnected() {
            
            let storyboard = UIStoryboard(
                name: "Main",
                bundle: nil
            )
            
            let detailsVC =
            storyboard.instantiateViewController(
                withIdentifier:
                    "LeagueDetailsViewController"
            ) as! LeaguesDetailsCollectionViewController
            
            detailsVC.sport = selectedSport ?? .football
            
            let leaguesId = presenter.leagues[indexPath.item].leagueKey ?? 0
            detailsVC.leagueID = String(leaguesId)
            
            navigationController?.pushViewController(
                detailsVC,
                animated: true
            )
            
        } else {
            
            let alert = UIAlertController(
                title: "Offline",
                message: "No Internet Connection",
                preferredStyle: .alert
            )
            
            alert.addAction(
                UIAlertAction(
                    title: "OK",
                    style: .default
                )
            )
            
            present(alert, animated: true)
        }
    }
}

// Search

extension LeaguesListViewController:
UISearchBarDelegate {
    
    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {
        
        presenter.searchLeague(
            text: searchText
        )
    }
}

//  View Protocol

extension LeaguesListViewController:
LeaguesViewProtocol {
    
    func renderLeagues() {
        
        hideLoadingIndecator()
        
        tableView.reloadData()
    }
    
    func renderError(message: String) {
        
        hideLoadingIndecator()
        
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default
            )
        )
        
        present(alert, animated: true)
    }
}

//  Favourite Delegate

extension LeaguesListViewController:
LeagueCellDelegate {
    
    func didTapFavourite(at cell: LeagueCell) {
        
        guard let indexPath =
                tableView.indexPath(for: cell)
        else { return }
        
        let league =
        presenter.filteredLeagues[indexPath.row]
        
        let leagueID =
        Int64(league.leagueKey ?? 0)
        
        let isFavourite =
        FavouriteManager.shared.isFavourite(
            id: leagueID
        )
        
        //  Remove
        
        if isFavourite {
            
            FavouriteManager.shared.deleteLeague(
                id: leagueID
            )
            
            cell.favouriteButton.setImage(
                UIImage(systemName: "heart"),
                for: .normal
            )
            
            cell.favouriteButton.tintColor =
            .lightGray
            
        } else {
            
            let leagueImageData =
            cell.leagueImage.image?
                .jpegData(
                    compressionQuality: 0.8
                )
            
            let countryImageData =
            cell.countryImage.image?
                .jpegData(
                    compressionQuality: 0.8
                )
            
            FavouriteManager.shared.saveLeague(
                league: league,
                leagueImage: leagueImageData,
                countryImage: countryImageData
            )
            
            cell.favouriteButton.setImage(
                UIImage(systemName: "heart.fill"),
                for: .normal
            )
            
            cell.favouriteButton.tintColor =
            .systemRed
        }
    }

}
