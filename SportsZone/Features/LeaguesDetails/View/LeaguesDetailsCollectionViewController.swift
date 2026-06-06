//
//  LeaguesDetailsCollectionViewController.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 19/05/2026.
//

import SkeletonView
import UIKit

private let leagueInfoIdentifire = "LeagueInfoCell"
private let eventsIdentifier = "EventCellId"
private let teamsIdentifier = "TeamsCell"
private let headerIdentifire = "HeaderViewItem"
private let emptyCellIdentifire = "EmptyCollectionCell"

class LeaguesDetailsCollectionViewController: UICollectionViewController {

    var sport: SportType = .football
    var leagueData: League?
    var leagueID: String?

    private var presenter: LeaguesDetailsPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        leagueID = String(leagueData?.leagueKey ?? 0)
        
        setupCollectionView()
        setupPresenter()
        print("sport type \(sport)")
    }

    private func setupPresenter() {
        presenter = LeaguesDetailsPresenter()
        presenter.view = self

        let calendar = Calendar.current
        let today = Date()
        let nextWeek = calendar.date(byAdding: .day, value: 400, to: today)!
        let lastWeek = calendar.date(byAdding: .day, value: -400, to: today)!

        presenter.loadData(
            sport: sport,
            leagueID: leagueID ?? "0",
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

        collectionView.register(
            UINib(nibName: "EmptyCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: emptyCellIdentifire
        )

        collectionView.collectionViewLayout = createLayout()
    }

    private func createLayout() -> UICollectionViewLayout {

        return UICollectionViewCompositionalLayout {
            [weak self] sectionIndex, environment in

            guard let self = self else { return nil }

            return self.createSection(for: sectionIndex)
        }
    }

    private func createSection(for section: Int) -> NSCollectionLayoutSection {

        if presenter.isLoading {
            switch section {
            case 0: return setupLeagueInfoSection()
            case 1: return setupUpcomingEventsSection()
            case 2: return setupTeamsSection()
            case 3: return setupLastEventsSection()
            default: return emptySectionLayout(height: 220)
            }
        }

        switch section {
        case 0: return setupLeagueInfoSection()

        case 1:
            return presenter.upcomingEvents.isEmpty
                ? emptySectionLayout(height: 220)
                : setupUpcomingEventsSection()

        case 2:
            if sport == .tennis {
                return presenter.tennisPlayers.isEmpty
                    ? emptySectionLayout(height: 180)
                    : setupTeamsSection()
            } else {
                return presenter.teams.isEmpty
                    ? emptySectionLayout(height: 180)
                    : setupTeamsSection()
            }

        case 3:
            return presenter.latestEvents.isEmpty
                ? emptySectionLayout(height: 250)
                : setupLastEventsSection()

        default:
            return emptySectionLayout(height: 220)
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch section {
        case 0: return 1
        case 1:
            return presenter.upcomingEvents.isEmpty
                ? 1 : presenter.upcomingEvents.count
        case 2:
            if sport == .tennis {
                return presenter.tennisPlayers.isEmpty
                    ? 1 : presenter.tennisPlayers.count
            } else {
                return presenter.teams.isEmpty ? 1 : presenter.teams.count
            }
        case 3:
            return presenter.latestEvents.isEmpty
                ? 1 : presenter.latestEvents.count
        default: return 0
        }
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        if presenter.isLoading {
            switch indexPath.section {
            case 0:
                let cell =
                    collectionView.dequeueReusableCell(
                        withReuseIdentifier: leagueInfoIdentifire,
                        for: indexPath
                    ) as! LeagueInfoCell
                return cell
            case 1, 3:
                let cell =
                    collectionView.dequeueReusableCell(
                        withReuseIdentifier: eventsIdentifier,
                        for: indexPath
                    ) as! EventCell
                return cell
            case 2:
                let cell =
                    collectionView.dequeueReusableCell(
                        withReuseIdentifier: teamsIdentifier,
                        for: indexPath
                    ) as! TeamsCollectionViewCell
                return cell
            default:
                break
            }
        }

        switch indexPath.section {
        case 0:
            let cell =
                collectionView.dequeueReusableCell(
                    withReuseIdentifier: leagueInfoIdentifire,
                    for: indexPath
                ) as! LeagueInfoCell

            cell.config(league: leagueData!)
            return cell
        case 1:
            if presenter.upcomingEvents.isEmpty {
                let cell =
                    collectionView.dequeueReusableCell(
                        withReuseIdentifier: emptyCellIdentifire,
                        for: indexPath
                    ) as! EmptyCollectionViewCell

                cell.config("No Upcoming Events Found")
                return cell
            } else {
                let cell =
                    collectionView.dequeueReusableCell(
                        withReuseIdentifier: eventsIdentifier,
                        for: indexPath
                    ) as! EventCell

                cell.config(event: presenter.upcomingEvents[indexPath.item])
                return cell
            }

        case 2:

            let isEmpty =
                sport == .tennis
                ? presenter.tennisPlayers.isEmpty
                : presenter.teams.isEmpty

            if isEmpty {

                let cell =
                    collectionView.dequeueReusableCell(
                        withReuseIdentifier: emptyCellIdentifire,
                        for: indexPath
                    ) as! EmptyCollectionViewCell

                cell.config(
                    sport == .tennis
                        ? "No Players Found"
                        : "No Teams Found"
                )

                return cell

            } else {

                let cell =
                    collectionView.dequeueReusableCell(
                        withReuseIdentifier: teamsIdentifier,
                        for: indexPath
                    ) as! TeamsCollectionViewCell

                if sport == .tennis {
                    cell.config(
                        tennisPlayer: presenter.tennisPlayers[indexPath.item]
                    )
                } else {
                    cell.config(
                        team: presenter.teams[indexPath.item]
                    )
                }

                return cell
            }

        case 3:
            if presenter.latestEvents.isEmpty {
                let cell =
                    collectionView.dequeueReusableCell(
                        withReuseIdentifier: emptyCellIdentifire,
                        for: indexPath
                    ) as! EmptyCollectionViewCell

                cell.config("No Latest Events Found")
                return cell
            } else {
                let cell =
                    collectionView.dequeueReusableCell(
                        withReuseIdentifier: eventsIdentifier,
                        for: indexPath
                    ) as! EventCell

                cell.config(event: presenter.latestEvents[indexPath.item])
                return cell
            }

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
        case 1:
            header.cofig(header: "Upcoming Events")
        case 2:
            if sport == .tennis {
                header.cofig(header: "Players")
            } else {
                header.cofig(header: "Teams")
            }
        case 3:
            header.cofig(header: "Latest Events")
        default:
            break
        }

        return header
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {

        guard indexPath.section == 1 else { return }
        guard !presenter.teams.isEmpty else { return }

        let selectedTeam = presenter.teams[indexPath.item]

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let teamsDetailesVC =
            storyboard.instantiateViewController(
                withIdentifier: "TeamDetailsScreen"
            ) as! TeamDetailesViewController

        teamsDetailesVC.sport = self.sport
        teamsDetailesVC.teamId = String(selectedTeam.teamKey)

        navigationController?.pushViewController(
            teamsDetailesVC,
            animated: true
        )

    }
}

extension LeaguesDetailsCollectionViewController {
    func setupLeagueInfoSection() -> NSCollectionLayoutSection {
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
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(100)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        //section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 16,
            bottom: 16,
            trailing: 16
        )

        return section
    }

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
            heightDimension: .absolute(250)
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

    private func emptySectionLayout(height: Int) -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(CGFloat(height))
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: itemSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 16,
            bottom: 32,
            trailing: 16
        )
        section.boundarySupplementaryItems = [self.createSectionHeader()]

        return section
    }
}

extension LeaguesDetailsCollectionViewController: LeaguesDetailsViewProtocol {
    func showLoading() {
        DispatchQueue.main.async {
            //self.showLoadingIndecator()
            self.collectionView.isSkeletonable = true
            self.collectionView.showAnimatedGradientSkeleton(
                usingGradient: SkeletonGradient(
                    baseColor: .systemGray5,
                    secondaryColor: .systemGray4
                ),
                animation: nil,
                transition: .crossDissolve(0.25)
            )
        }
    }

    func hideLoading() {
        DispatchQueue.main.async {
            //self.hideLoadingIndecator()
            self.collectionView.stopSkeletonAnimation()
            self.collectionView.hideSkeleton(reloadDataAfter: false)
        }
    }

    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.setCollectionViewLayout(
                self.createLayout(),
                animated: false
            )
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

extension LeaguesDetailsCollectionViewController:
    SkeletonCollectionViewDataSource
{
    func collectionSkeletonView(
        _ skeletonView: UICollectionView,
        cellIdentifierForItemAt indexPath: IndexPath
    ) -> SkeletonView.ReusableCellIdentifier {
        switch indexPath.section {
        case 0: return leagueInfoIdentifire
        case 1, 3: return eventsIdentifier
        case 2: return teamsIdentifier
        default: return eventsIdentifier
        }
    }

    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return 4
    }

    func collectionSkeletonView(
        _ skeletonView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch section {
        case 0: return 1
        default: return 5
        }
    }
}
