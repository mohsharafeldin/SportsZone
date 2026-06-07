//
//  SplashViewController.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 06/06/2026.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var appNameLable: UILabel!
    @IBOutlet weak var logoImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
    }

    private func setupUI() {
        logoImage.layer.cornerRadius = logoImage.frame.width / 2
        logoImage.clipsToBounds = true

        appNameLable.font = UIFont(name: "Nunito-Bold", size: 24)
    }

    private func startAnimation() {

        UIView.animate(
            withDuration: 0.8,
            delay: 0.2,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.5
        ) {
            self.logoImage.transform = .identity
            self.logoImage.alpha = 1
        }

        appNameLable.transform = CGAffineTransform(translationX: 0, y: 20)
        UIView.animate(withDuration: 0.6, delay: 0.7) {
            self.appNameLable.alpha = 1
            self.appNameLable.transform = .identity
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.navigateToNext()
        }
    }

    private func navigateToNext() {
        let hasSeenOnboarding = UserDefaults.standard.bool(
            forKey: "hasSeenOnboarding"
        )
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let nextVC: UIViewController
        if hasSeenOnboarding {
            nextVC = storyboard.instantiateViewController(
                withIdentifier: "MainTabBarController"
            )
        } else {
            nextVC = storyboard.instantiateViewController(
                withIdentifier: "OnboardingContainerViewController"
            )
        }

        if let scene = UIApplication.shared.connectedScenes.first
            as? UIWindowScene,
            let window = scene.windows.first
        {
            window.rootViewController = nextVC
            UIView.transition(
                with: window,
                duration: 0.5,
                options: .transitionCrossDissolve,
                animations: nil
            )
        }
    }
}
