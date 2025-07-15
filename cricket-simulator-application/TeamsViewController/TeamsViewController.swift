//
//  TeamsViewController.swift
//  cricket-simulator-application
//
//  Created by Sachin Verma on 02/07/25.
//

import UIKit

class TeamsViewController: UIViewController {
    var allTeams: [TeamDetail] = []
    var selectedTeams: [TeamDetail] = [] {
        didSet {
            startMatchButton.isEnabled = selectedTeams.count == 2
        }
    }

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    let startMatchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("START MATCH", for: .normal)
        button.backgroundColor = Consts.greenColor
        button.tintColor = .white
        button.isEnabled = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Consts.greenColor
        
        title = "Teams List"
        setupStartMatchButton()
        setupCollectionView()
        fetchTeams()
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(TeamsCollectionViewCell.self, forCellWithReuseIdentifier: TeamsCollectionViewCell.identifier)

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = true

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: startMatchButton.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }

    private func setupStartMatchButton() {
        view.addSubview(startMatchButton)
        startMatchButton.translatesAutoresizingMaskIntoConstraints = false
        startMatchButton.addTarget(self, action: #selector(startMatch), for: .touchUpInside)

        NSLayoutConstraint.activate([
            startMatchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            startMatchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            startMatchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            startMatchButton.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    private func fetchTeams() {
        guard let data = Consts.fetchTeamsData() else {
            return
        }
        allTeams = data
        collectionView.reloadData()
    }

    @objc private func startMatch() {
        let matchVC = MatchViewController(teams: selectedTeams)
        navigationController?.pushViewController(matchVC, animated: true)
    }
}

extension TeamsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allTeams.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamsCollectionViewCell.identifier, for: indexPath) as! TeamsCollectionViewCell
        cell.setData(data: allTeams[indexPath.item])
        return cell
    }
}

extension TeamsViewController: UICollectionViewDelegate {
    // Select only two teams at most.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard selectedTeams.count < 2,
              let cell = collectionView.cellForItem(at: indexPath) as? TeamsCollectionViewCell else {
            return
        }
        let team = allTeams[indexPath.item]
        if !selectedTeams.contains(where: { $0.name == team.name }) {
            selectedTeams.append(team)
        }
        cell.toggleBackground(selected: true)
    }

    // De-select the selected team.
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard selectedTeams.count >= 0,
              let cell = collectionView.cellForItem(at: indexPath) as? TeamsCollectionViewCell else {
            return
        }
        let team = allTeams[indexPath.item]
        selectedTeams.removeAll(where: { $0.name == team.name })
        cell.toggleBackground(selected: false)
    }
}


