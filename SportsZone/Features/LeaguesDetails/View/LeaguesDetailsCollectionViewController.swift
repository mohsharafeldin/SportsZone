//
//  LeaguesDetailsCollectionViewController.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 19/05/2026.
//

import UIKit

private let eventsIdentifier = "EventCellId"
private let teamsIdentifier = "TeamsCell"
private let headerIdentifire = "HeaderViewItem"

class LeaguesDetailsCollectionViewController: UICollectionViewController {

    var sport: SportType = .football
    var leagueID: String = "152"

    private var presenter: LeaguesDetailsPresenter!    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupPresenter()

    }

    private func setupPresenter() {
        presenter = LeaguesDetailsPresenter()
        presenter.view = self

        let calendar = Calendar.current
        let today = Date()
        let nextWeek = calendar.date(byAdding: .day, value: 7, to: today)!
        let lastWeek = calendar.date(byAdding: .day, value: -7, to: today)!

        presenter.loadData(
            sport: sport,
            leagueID: leagueID,
            from: formattedDate(lastWeek),
            to: formattedDate(nextWeek)
        )

    }

    private func setupCollectionView() {
        collectionView.register(
            UINib(nibName: "HeaderView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionView
                .elementKindSectionHeader,
            withReuseIdentifier: headerIdentifire
        )

        collectionView.register(
            UINib(nibName: "EventCell", bundle: nil),
            forCellWithReuseIdentifier: eventsIdentifier
        )

        let layout = UICollectionViewCompositionalLayout { index, environment in
            if index == 0 {
                return self.setupUpcomingEventsSection()
            } else if index == 1 {
                return self.setupTeamsSection()
            } else {
                return self.setupLastEventsSection()
            }
        }
        collectionView.setCollectionViewLayout(layout, animated: true)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch section {
        case 0: return presenter.upcomingEvents.count
        case 1: return presenter.teams.count
        case 2: return presenter.latestEvents.count
        default: return 0
        }
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        switch indexPath.section {
        case 0:
            let cell =
                collectionView.dequeueReusableCell(
                    withReuseIdentifier: eventsIdentifier,
                    for: indexPath
                ) as! EventCell

            cell.config(event: presenter.upcomingEvents[indexPath.item])
            return cell

        case 1:
            let cell =
                collectionView.dequeueReusableCell(
                    withReuseIdentifier: teamsIdentifier,
                    for: indexPath
                ) as! TeamsCollectionViewCell

            cell.config(team: presenter.teams[indexPath.item])
            return cell

        case 2:
            let cell =
                collectionView.dequeueReusableCell(
                    withReuseIdentifier: eventsIdentifier,
                    for: indexPath
                ) as! EventCell

            cell.config(event: presenter.latestEvents[indexPath.item])
            return cell

        default:
            let cell =
                collectionView.dequeueReusableCell(
                    withReuseIdentifier: eventsIdentifier,
                    for: indexPath
                ) as! EventCell

            return cell
        }
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {

        let header =
            collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "HeaderViewItem",
                for: indexPath
            ) as! HeaderView

        switch indexPath.section {
        case 0:
            header.cofig(header: "Upcoming Events")
        case 1:
            header.cofig(header: "Teams")
        case 2:
            header.cofig(header: "Latest Events")
        default:
            break
        }

        return header
    }
}

extension LeaguesDetailsCollectionViewController {
    func setupUpcomingEventsSection() -> NSCollectionLayoutSection {
        
        //item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 8,
            bottom: 0,
            trailing: 8
        )

        //group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.75),
            heightDimension: .absolute(220)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 16,
            bottom: 32,
            trailing: 16
        )
        section.boundarySupplementaryItems = [self.createSectionHeader()]

        return section
    }

    func setupTeamsSection() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 4,
            bottom: 0,
            trailing: 4
        )

        //group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(150),
            heightDimension: .absolute(180)
        )
        let eventsGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        //section
        let section = NSCollectionLayoutSection(group: eventsGroup)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 16,
            bottom: 32,
            trailing: 16
        )
        section.boundarySupplementaryItems = [self.createSectionHeader()]

        return section
    }

    func setupLastEventsSection() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 8,
            bottom: 8,
            trailing: 8
        )

        //group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(230)
        )
        let eventsGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )

        //section
        let section = NSCollectionLayoutSection(group: eventsGroup)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 16,
            bottom: 32,
            trailing: 16
        )
        section.boundarySupplementaryItems = [self.createSectionHeader()]

        return section
    }

    private func createSectionHeader()
        -> NSCollectionLayoutBoundarySupplementaryItem
    {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(50)
        )

        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        header.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 8,
            trailing: 0
        )

        return header
    }
}

extension LeaguesDetailsCollectionViewController: LeaguesDetailsViewProtocol {
    func showLoading() {
        DispatchQueue.main.async {
            self.showLoadingIndecator()
        }
    }

    func hideLoading() {
        DispatchQueue.main.async {
            self.hideLoadingIndecator()
        }
    }

    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
