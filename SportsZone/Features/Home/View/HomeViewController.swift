//
//  HomeViewController.swift
//  SportsZone
//
//  Created by mohamed sharaf on 20/05/2026.
//



import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var sportsCollectionView: UICollectionView!
    
    var presenter: HomePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = HomePresenter(
            view: self,
            reachability: ReachabilityManager.shared
        )
        
        setupCollectionView()
        
        presenter.viewDidLoad()
    }
    
    private func setupCollectionView() {
        sportsCollectionView.delegate = self
        sportsCollectionView.dataSource = self
        
        if let layout = sportsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = .zero
        }
    }
}


extension HomeViewController: HomeViewProtocol {
    
    func reloadData() {
        sportsCollectionView.reloadData()
    }
    
    func showNoInternetAlert() {
        let alert = UIAlertController(
            title: "No Internet Connection",
            message: "An internet connection is required to load leagues.\n\nPlease check your network and try again.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func navigateToLeaguesList(with sport: SportType) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "LeaguesListViewController") as? LeaguesListViewController else { return }
        
        vc.selectedSport = sport
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SportsCell
        
        // Calculate the flat index for the 2x2 grid
        let index = indexPath.section * 2 + indexPath.row
        
        // Ask the presenter for the data instead of accessing the array directly
        let item = presenter.getSport(at: index)
        
        cell.sportName.text = item.name
        cell.sportImage.image = UIImage(named: item.imageName)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.section * 2 + indexPath.row
        
        presenter.didSelectSport(at: index)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = 16.0
        let totalSpace = padding * 3
        let width = (collectionView.frame.width - totalSpace) / 2
        return CGSize(width: width, height: width * 1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 10, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
