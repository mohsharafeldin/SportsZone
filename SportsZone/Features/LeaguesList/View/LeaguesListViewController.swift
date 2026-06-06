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
    
    private let emptyStateLabel: UILabel = {
        
        let label = UILabel()
        
        label.textAlignment = .center
        
        label.textColor = .secondaryLabel
        
        label.numberOfLines = 0
        
        label.font = .systemFont(
            ofSize: 18,
            weight: .medium
        )
        
        return label
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Leagues"
        
        presenter = LeaguesPresenter(
            view: self,
            repo: LeaguesRepo(),
            reachability: ReachabilityManager.shared
        )
        
        setupTableView()
        
        setupSearchController()
        
        if let sport = selectedSport {
            
            showLoadingIndecator()
            
            presenter.getLeagues(for: sport)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
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
    
    func updateEmptyState() {
        
        if presenter.filteredLeagues.isEmpty {
            
            let emptyView = UIView(
                frame: tableView.bounds
            )
            
            let imageView = UIImageView(
                image: UIImage(
                    systemName: "magnifyingglass"
                )
            )
            
            imageView.tintColor = .systemGray
            
            imageView.translatesAutoresizingMaskIntoConstraints =
            false
            
            imageView.contentMode = .scaleAspectFit
            
            let label = UILabel()
            
            label.text =
            "No leagues found\nTry another search term"
            
            label.textAlignment = .center
            
            label.numberOfLines = 0
            
            label.textColor = .secondaryLabel
            
            label.translatesAutoresizingMaskIntoConstraints =
            false
            
            emptyView.addSubview(imageView)
            
            emptyView.addSubview(label)
            
            NSLayoutConstraint.activate([
                
                imageView.centerXAnchor.constraint(
                    equalTo: emptyView.centerXAnchor
                ),
                
                imageView.centerYAnchor.constraint(
                    equalTo: emptyView.centerYAnchor,
                    constant: -40
                ),
                
                imageView.widthAnchor.constraint(
                    equalToConstant: 60
                ),
                
                imageView.heightAnchor.constraint(
                    equalToConstant: 60
                ),
                
                label.topAnchor.constraint(
                    equalTo: imageView.bottomAnchor,
                    constant: 16
                ),
                
                label.centerXAnchor.constraint(
                    equalTo: emptyView.centerXAnchor
                ),
                
                label.leadingAnchor.constraint(
                    greaterThanOrEqualTo:
                        emptyView.leadingAnchor,
                    constant: 20
                ),
                
                label.trailingAnchor.constraint(
                    lessThanOrEqualTo:
                        emptyView.trailingAnchor,
                    constant: -20
                )
            ])
            
            tableView.backgroundView = emptyView
            
        } else {
            
            tableView.backgroundView = nil
        }
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
                UIImage(named: "NoLeague")
        )
        
        //  Country Image
        
        cell.countryImage.sd_setImage(
            with: URL(
                string: league.countryLogo ?? ""
            ),
            placeholderImage:
                UIImage(named: "NoCountry")
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

        guard presenter.canOpenLeagueDetails() else {

            let alert = UIAlertController(
                title: "No Internet Connection",
                message: "Internet is required to view league details.",
                preferredStyle: .alert
            )

            alert.addAction(
                UIAlertAction(
                    title: "OK",
                    style: .default
                )
            )

            present(alert, animated: true)

            return
        }

        let storyboard = UIStoryboard(
            name: "Main",
            bundle: nil
        )

        let detailsVC =
        storyboard.instantiateViewController(
            withIdentifier: "LeagueDetailsViewController"
        ) as! LeaguesDetailsCollectionViewController

        detailsVC.sport =
        selectedSport ?? .football

        let league: League = presenter.filteredLeagues[indexPath.row]

        detailsVC.leagueData = league

        navigationController?.pushViewController(
            detailsVC,
            animated: true
        )
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
        updateEmptyState()
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
            
            let alert = UIAlertController(
                title: "Remove Favourite",
                message: "Remove this league from favourites?",
                preferredStyle: .alert
            )
            
            alert.addAction(
                UIAlertAction(
                    title: "Cancel",
                    style: .cancel
                )
            )
            
            alert.addAction(
                UIAlertAction(
                    title: "Remove",
                    style: .destructive
                ) { _ in
                    
                    FavouriteManager.shared.deleteLeague(
                        id: leagueID
                    )
                    
                    cell.favouriteButton.setImage(
                        UIImage(systemName: "heart"),
                        for: .normal
                    )
                    
                    cell.favouriteButton.tintColor =
                    .lightGray
                }
            )
            
            present(alert, animated: true)
            
            return
        }else {
            
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
