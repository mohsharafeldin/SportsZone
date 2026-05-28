//
//  TeamDetailesViewController.swift
//  SportsZone
//
//  Created by Nadin Ahmed on 24/05/2026.
//

import UIKit

class TeamDetailesViewController: UIViewController {

    var sport: SportType = .football
    var teamId: String = "79"

    private var presenter: TeamDetailsPresenter!

    @IBOutlet weak var teamLogo: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamCoachLable: UILabel!
    @IBOutlet weak var teamNumOfPlayersLabel: UILabel!
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var playersTableView: UITableView!
    @IBOutlet weak var teamInfoView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupStyles()
        setupPresenter()

        playersTableView.register(
            UINib(nibName: "PlayerCell", bundle: nil),
            forCellReuseIdentifier: "PlyerTableCell"
        )
    }

    private func setupStyles() {
        teamLogo.layer.cornerRadius = teamLogo.frame.width / 2
        teamLogo.clipsToBounds = true

        teamNameLabel.font = UIFont(name: "Nunito-Bold", size: 24)
        teamCoachLable.font = UIFont(name: "Nunito-SemiBold", size: 18)
        teamNumOfPlayersLabel.font = UIFont(name: "Nunito-SemiBold", size: 18)
        playerLabel.font = UIFont(name: "Nunito-Bold", size: 24)
        
        addShadow(to: teamInfoView)
    }

    private func setupPresenter() {
        presenter = TeamDetailsPresenter()
        presenter.view = self

        presenter.loadData(sport: sport, teamID: teamId)
    }

}

extension TeamDetailesViewController: UITableViewDelegate, UITableViewDataSource
{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        presenter.teamData?.players?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: "PlyerTableCell",
                for: indexPath
            ) as! PlayerCell

        if let player = presenter.teamData?.players?[indexPath.row] {
            cell.config(player: player)
        }
        return cell
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 200
    }
}

extension TeamDetailesViewController: TeamDetailsViewProtocol {
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

    func loadData() {
        DispatchQueue.main.async {
            let data = self.presenter.teamData

            self.teamNameLabel.text = data?.teamName
            self.teamCoachLable.text =
                "Coach: \(data?.coaches?.first?.coachName ?? "N/A")"
            self.teamNumOfPlayersLabel.text =
                "Players: \(data?.players?.count ?? 0)"
            self.teamLogo.sd_setImage(
                with: URL(string: data!.teamLogo),
                placeholderImage: UIImage(systemName: "logo.png")
            )
            self.playersTableView.reloadData()
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
