//
//  FavouriteLeaguesViewController.swift
//  SportsZone
//
//  Created by mohamed sharaf on 23/05/2026.
//

import UIKit

import UIKit

class FavouriteLeaguesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()

    var presenter: FavouriteLeaguesPresenter!

    let searchController =
    UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Favourite Leagues"

        presenter = FavouriteLeaguesPresenter(view: self)

        setupTableView()

        setupSearchController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.loadFavourites()
    }

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
}

// MARK: - TableView

extension FavouriteLeaguesViewController:
UITableViewDelegate,
UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        return presenter.filteredLeagues.count
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
        presenter.filteredLeagues[indexPath.row]

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

        if let data = fav.countryLogo {

            cell.countryImage.image =
            UIImage(data: data)

        } else {

            cell.countryImage.image =
            UIImage(named: "placeholder")
        }

        cell.leagueImage.layer.cornerRadius =
        cell.leagueImage.frame.width / 2

        cell.leagueImage.clipsToBounds = true

        cell.countryImage.layer.cornerRadius =
        cell.countryImage.frame.width / 2

        cell.countryImage.clipsToBounds = true

        return cell
    }

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

            let alert = UIAlertController(
                title: "Remove Favourite",
                message: "Are you sure you want to delete this league?",
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
                    title: "Delete",
                    style: .destructive
                ) { _ in

                    self.presenter.deleteLeague(
                        at: indexPath
                    )
                }
            )

            self.present(alert, animated: true)

            completion(true)
        }

        return UISwipeActionsConfiguration(
            actions: [deleteAction]
        )
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {

        tableView.deselectRow(
            at: indexPath,
            animated: true
        )

        let storyboard = UIStoryboard(
            name: "Main",
            bundle: nil
        )

        let detailsVC =
        storyboard.instantiateViewController(
            withIdentifier:
            "LeagueDetailsViewController"
        )

        navigationController?.pushViewController(
            detailsVC,
            animated: true
        )
    }
}

// MARK: - Search

extension FavouriteLeaguesViewController:
UISearchBarDelegate {

    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {

        presenter.search(text: searchText)
    }
}

// MARK: - View Protocol

extension FavouriteLeaguesViewController:
FavouriteLeaguesViewProtocol {

    func renderFavourites() {

        tableView.reloadData()
    }

    func showEmptyState(message: String) {

        emptyLabel.text = message

        tableView.backgroundView =
        emptyLabel
    }

    func hideEmptyState() {

        tableView.backgroundView = nil
    }
}

