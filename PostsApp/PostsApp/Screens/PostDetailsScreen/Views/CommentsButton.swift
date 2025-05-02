//
//  ShowCommentsButton.swift
//  PostsApp
//
//  Created by Juan Camilo Mendieta Hernández on 30/04/25.
//

import UIKit

class CommentsButton: UIButton {
    private let label = UILabel()
    private let arrowImageView = UIImageView()
    
    var isExpanded: Bool = false {
        didSet {
            updateArrowRotation()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButton()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpButton() {
        backgroundColor = .systemRed
        layer.cornerRadius = 8
        clipsToBounds = true
        
        label.text = "Comments"
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .bold)
        
        arrowImageView.image = UIImage(systemName: "chevron.down")
        arrowImageView.tintColor = .white
        arrowImageView.contentMode = .scaleAspectFit
        
        label.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            arrowImageView.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8),
            arrowImageView.widthAnchor.constraint(equalToConstant: 16),
            arrowImageView.heightAnchor.constraint(equalToConstant: 16),
        ])
    }
    
    private func updateArrowRotation() {
        let angle: CGFloat = isExpanded ? .pi : 0
        UIView.animate(withDuration: 0.25) {
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: angle)
        }
    }
}
