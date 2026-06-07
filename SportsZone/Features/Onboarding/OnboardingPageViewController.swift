//
//  OnboardingPageViewController.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 06/06/2026.
//

import UIKit

class OnboardingPageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var sutitleLable: UILabel!

    var page: OnboardingPage?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        guard let page = page else { return }

        imageView.image = UIImage(named: page.imageName)
        titleLable.text = page.title
        sutitleLable.text = page.subtitle

    }

    private func setupUI(){
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        
        titleLable.font = UIFont(name: "Nunito-Bold", size: 24)
        sutitleLable.font = UIFont(name: "Nunito-Regular", size: 20)
    }
}
