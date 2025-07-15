//
//  TeamsCollectionViewCell.swift
//  cricket-simulator-application
//
//  Created by Sachin Verma on 02/07/25.
//

import Foundation
import UIKit

class TeamsCollectionViewCell: UICollectionViewCell {
    static let identifier = "TeamsCollectionViewCell"

    let imageView = UIImageView()
    let nameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        nameLabel.font = .systemFont(ofSize: 30, weight: .light)
        nameLabel.numberOfLines = 0

        let stackView = UIStackView(arrangedSubviews: [imageView, nameLabel])
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center

        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),

            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(data team: TeamDetail) {
        nameLabel.text = team.name
        imageView.image = nil
        loadImage(from: team.flagURL)
    }

    func toggleBackground(selected: Bool) {
        self.backgroundColor = selected ? .gray : .white
    }

    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }

            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
            }
        }.resume()
    }
}
