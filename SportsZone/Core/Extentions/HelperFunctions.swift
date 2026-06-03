//
//  HelperFunctions.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 23/05/2026.
//

import Foundation
import UIKit

func formattedDate(_ date: Date) -> String {
    let f = DateFormatter()
    f.dateFormat = "yyyy-MM-dd"
    return f.string(from: date)
}

func addShadow(to view: UIView) {
    view.layer.cornerRadius = 12
    view.layer.masksToBounds = false
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOpacity = 0.1
    view.layer.shadowOffset = CGSize(width: 0, height: 2)
    view.layer.shadowRadius = 4
    view.layer.shadowPath = UIBezierPath(
        roundedRect: view.bounds,
        cornerRadius: view.layer.cornerRadius
    ).cgPath
}

extension UIViewController {

    func showLoadingIndecator() {

        if view.viewWithTag(999) != nil { return }

        let indicator = UIActivityIndicatorView(style: .large)
        indicator.tag = 999
        indicator.translatesAutoresizingMaskIntoConstraints = false

        indicator.color = UIColor(named: "PrimaryColor")

        indicator.startAnimating()
        indicator.hidesWhenStopped = true

        view.addSubview(indicator)

        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func hideLoadingIndecator() {

        if let indicator = view.viewWithTag(999)
            as? UIActivityIndicatorView {

            indicator.stopAnimating()
            indicator.removeFromSuperview()
        }
    }
}
