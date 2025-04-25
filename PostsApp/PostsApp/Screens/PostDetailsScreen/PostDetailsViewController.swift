//
//  PostDetailsViewController.swift
//  PostsApp
//
//  Created by Juan Camilo Mendieta Hernández on 24/04/25.
//

import UIKit

final class PostDetailsViewController: UIViewController {
    private let viewModel: PostDetailsViewModelProtocol
    private let userId: String
    private let postId: String
    
    lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.text = ""
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 0
        return title
    }()
    
    lazy var postDescriptionLabel: UITextView = {
        let description = UITextView()
        description.text = ""
        description.translatesAutoresizingMaskIntoConstraints = false
        description.isEditable = false
        return description
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .gray

        return spinner
    }()
    
    init(viewModel: PostDetailsViewModelProtocol, userId: String, postId: String) {
        self.viewModel = viewModel
        self.userId = userId
        self.postId = postId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Post details"
        view?.backgroundColor = .white
        
        setUpStack()
        setupSpinner()
        showSpinner()
        Task {
            await fetchPost()
        }
    }
    
    private func setUpStack() {
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(postDescriptionLabel)
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            stack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupSpinner() {
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func showSpinner() {
        spinner.startAnimating()
        spinner.isHidden = false
    }

    private func hideSpinner() {
        spinner.stopAnimating()
        spinner.isHidden = true
    }
    
    @MainActor
    private func fetchPost() async {
        await viewModel.fetchPostDetails(postId: postId, userId: userId)
        
        self.titleLabel.text = "Title: \(self.viewModel.model.post.title)"
        self.postDescriptionLabel.text = self.viewModel.model.post.body
        
        hideSpinner()
    }
}
