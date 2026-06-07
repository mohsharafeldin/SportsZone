//
//  OnboardingContainer.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 06/06/2026.
//

import Foundation
import UIKit

class OnboardingContainerViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!

    private var pageVC: UIPageViewController!

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            imageName: "onboarding1.png",
            title: "Discover Sports",
            subtitle:
                "Browse a variety of sports and leagues from around the world."
        ),
        OnboardingPage(
            imageName: "onboarding2.png",
            title: "Track Leagues",
            subtitle:
                "Stay updated with live events, matches, and real-time scores."
        ),
        OnboardingPage(
            imageName: "onboarding3",
            title: "Favorite Teams",
            subtitle:
                "Save your favorite leagues and teams for a personalized feed."
        ),
    ]

    private var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPageViewController()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
    }

    private func setupPageViewController() {
        pageVC = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        pageVC.dataSource = self
        pageVC.delegate = self

        addChild(pageVC)
        containerView.addSubview(pageVC.view)
        pageVC.view.frame = containerView.bounds
        pageVC.didMove(toParent: self)

        if let firstVC = makePageVC(at: 0) {
            pageVC.setViewControllers(
                [firstVC],
                direction: .forward,
                animated: false
            )
        }
    }

    private func makePageVC(at index: Int) -> OnboardingPageViewController? {
        guard index >= 0 && index < pages.count else { return nil }

        let vc = storyboard?.instantiateViewController(
                withIdentifier: "OnboardingPageViewController"
            ) as? OnboardingPageViewController

        vc?.page = pages[index]
        vc?.view.tag = index
        return vc
    }

    @IBAction func nextTapped(_ sender: UIButton) {
        if currentIndex < pages.count - 1 {
            currentIndex += 1
            if let vc = makePageVC(at: currentIndex) {
                pageVC.setViewControllers(
                    [vc],
                    direction: .forward,
                    animated: true
                )
            }
            updateUI()
        } else {
            finishOnboarding()
        }
    }

    private func updateUI() {
        pageControl.currentPage = currentIndex
        let isLast = currentIndex == pages.count - 1
        nextButton.setTitle(isLast ? "Get Started" : "Next", for: .normal)
    }

    private func finishOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBar = storyboard.instantiateViewController(
            withIdentifier: "MainTabBarController"
        )

        if let scene = UIApplication.shared.connectedScenes.first
            as? UIWindowScene,
            let window = scene.windows.first
        {
            window.rootViewController = tabBar
            UIView.transition(
                with: window,
                duration: 0.4,
                options: .transitionCrossDissolve,
                animations: nil
            )
        }
    }
}

extension OnboardingContainerViewController: UIPageViewControllerDelegate,
    UIPageViewControllerDataSource
{
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        let index = viewController.view.tag - 1
        return makePageVC(at: index)
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        let index = viewController.view.tag + 1
        return makePageVC(at: index)
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard completed, let currentVC = pageViewController.viewControllers?.first
        else { return }

        currentIndex = currentVC.view.tag
        updateUI()
    }
}
