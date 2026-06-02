//
//  HomeViewController.swift
//  SportsZone
//
//  Created by mohamed sharaf on 20/05/2026.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    
    let sports = [
            ("Cricket", "cricket"),
            ("Basketball", "basketball"),
            ("Tennis", "tennis"),
            ("Football", "football")
        ]
    
    @IBOutlet weak var sportscollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sportscollectionView.delegate = self
        sportscollectionView.dataSource = self
        if let layout = sportscollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.estimatedItemSize = .zero
            }

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       let padding = 16.0
        let totalSpace = padding * 3
        let width = (collectionView.frame.width-totalSpace)/2
        
        return CGSize(width: width, height: width * 1.2)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 10, right: 16    )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SportsCell
        
        let index = indexPath.section * 2 + indexPath.row
            let item = sports[index]

            cell.sportName.text = item.0
            cell.sportImage.image = UIImage(named: item.1)
        
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let index = indexPath.section * 2 + indexPath.row
        
        let selectedSport = sports[index]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "LeaguesListViewController") as! LeaguesListViewController
        
        vc.selectedSport = SportType(rawValue: selectedSport.1)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
