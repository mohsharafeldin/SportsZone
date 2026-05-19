//
//  LeaguesDetailsCollectionViewController.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 19/05/2026.
//

import UIKit

private let upcomingEventsIdentifier = "UpcomingEventsCell"
private let teamsIdentifier = "TeamsCell"
private let lastEventsIdentifier = "LastEventsCell"

class LeaguesDetailsCollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewCompositionalLayout {index, environment in
            if index == 0 {
                return self.setupUpcomingEventsSection()
            }else if index == 1{
                return self.setupTeamsSection()
            }else{
                return self.setupLastEventsSection()
            }
        }
        collectionView.setCollectionViewLayout(layout, animated: true)
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch(indexPath.section){
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: upcomingEventsIdentifier, for: indexPath) as! UpcomingEventsCollectionViewCell
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: teamsIdentifier, for: indexPath) as! TeamsCollectionViewCell
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: lastEventsIdentifier, for: indexPath) as! LastEventsCollectionViewCell
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: lastEventsIdentifier, for: indexPath) as! LastEventsCollectionViewCell
            return cell
        }
    }
}

extension LeaguesDetailsCollectionViewController{
    func setupUpcomingEventsSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.75),
            heightDimension: .absolute(150)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)

        return section
    }
    
    func setupTeamsSection() -> NSCollectionLayoutSection{
        //item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1),
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
        
        //group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(100),
            heightDimension: .absolute(100),
        )
        let eventsGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        //section
        let section = NSCollectionLayoutSection(group: eventsGroup)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        return section
    }
    
    func setupLastEventsSection() -> NSCollectionLayoutSection{
        //item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1),
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0)
        
        //group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(200),
        )
        let eventsGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        //section
        let section = NSCollectionLayoutSection(group: eventsGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        return section
    }
}
