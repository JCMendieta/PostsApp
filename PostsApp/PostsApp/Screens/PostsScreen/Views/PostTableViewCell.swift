//
//  PostCell.swift
//  PostsApp
//
//  Created by Juan Camilo Mendieta Hernández on 6/05/25.
//

import UIKit

final class PostTableViewCell: UITableViewCell {
    static let reuseIdentifier = "PostTableViewCell"
    
    private let titleLabel = UILabel()
    private let starButton = UIButton(type: .system)
    var onStarTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        starButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(starButton)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: starButton.leadingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            starButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            starButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            starButton.widthAnchor.constraint(equalToConstant: 24),
            starButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        starButton.addTarget(self, action: #selector(starTapped), for: .touchUpInside)
    }
    
    @objc private func starTapped() {
        onStarTapped?()
    }
    
    func configure(with post: Post) {
        titleLabel.text = post.title
        let imageName = post.isFavorite ? "star.fill" : "star"
        let image = UIImage(systemName: imageName)
        starButton.setImage(image, for: .normal)
        starButton.tintColor = post.isFavorite ? .systemYellow : .lightGray
    }
}
