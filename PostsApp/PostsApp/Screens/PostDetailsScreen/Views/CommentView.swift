//
//  CommentView.swift
//  PostsApp
//
//  Created by Juan Camilo Mendieta Hernández on 1/05/25.
//

import UIKit

class CommentView: UIView {
    private let body = UILabel()
    
    init(comment: Comment) {
        super.init(frame: .zero)
        body.text = comment.body
        body.numberOfLines = 0
        body.font = .systemFont(ofSize: 14)
        body.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(body)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            body.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            body.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            body.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            body.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
        ])
        
        backgroundColor = .systemGray5
        layer.cornerRadius = 6
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
