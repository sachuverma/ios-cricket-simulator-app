//
//  TeamScoreView.swift
//  cricket-simulator-application
//
//  Created by Sachin Verma on 02/07/25.
//

import UIKit

class TeamScoreView: UIView {
    private let nameLabel = UILabel()
    private let scoreLabel = UILabel()
    private let oversLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .systemGray6
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 36)
        nameLabel.textAlignment = .left

        scoreLabel.font = UIFont.systemFont(ofSize: 24)
        scoreLabel.textAlignment = .left

        oversLabel.font = UIFont.systemFont(ofSize: 24)
        oversLabel.textAlignment = .right

        let scoreOversStack = UIStackView(arrangedSubviews: [scoreLabel, UIView(), oversLabel])
        scoreOversStack.axis = .horizontal
        scoreOversStack.spacing = 8
        scoreOversStack.distribution = .fill
        scoreOversStack.translatesAutoresizingMaskIntoConstraints = false

        let mainStack = UIStackView(arrangedSubviews: [nameLabel, scoreOversStack])
        mainStack.axis = .vertical
        mainStack.spacing = 8
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }

    func setData(name: String, score: String, overs: String, isBatting: Bool) {
        nameLabel.text = isBatting ? "\(name) (batting)" : name
        scoreLabel.text = "Score: \(score)"
        oversLabel.text = "Overs: \(overs)"
    }
}

