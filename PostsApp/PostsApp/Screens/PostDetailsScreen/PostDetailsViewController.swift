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
    private var showComments = false
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
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
    
    lazy var postDescriptionLabel: UILabel = {
        let description = UILabel()
        description.text = ""
        description.translatesAutoresizingMaskIntoConstraints = false
        description.numberOfLines = 10
        description.font = description.font.withSize(12)
        return description
    }()
    
    lazy var authorSection: UIView = {
        let authorSection = UIView()
        authorSection.layer.cornerRadius = 8
        authorSection.translatesAutoresizingMaskIntoConstraints = false
        return authorSection
    }()
    
    lazy var authorStack: UIStackView = {
        let authorStack = UIStackView()
        authorStack.axis = .vertical
        authorStack.spacing = 8
        authorStack.translatesAutoresizingMaskIntoConstraints = false
        return authorStack
    }()
    
    lazy var authorName: UILabel = {
        let authorName = UILabel()
        authorName.text = ""
        authorName.translatesAutoresizingMaskIntoConstraints = false
        authorName.numberOfLines = 0
        return authorName
    }()
    
    lazy var authorUserName: UILabel = {
        let authorUserName = UILabel()
        authorUserName.text = ""
        authorUserName.translatesAutoresizingMaskIntoConstraints = false
        authorUserName.numberOfLines = 0
        return authorUserName
    }()
    
    lazy var authorEmail: UILabel = {
        let authorEmail = UILabel()
        authorEmail.text = ""
        authorEmail.translatesAutoresizingMaskIntoConstraints = false
        authorEmail.numberOfLines = 0
        return authorEmail
    }()
    
    lazy var authorAddress: UILabel = {
        let authorAddress = UILabel()
        authorAddress.text = ""
        authorAddress.translatesAutoresizingMaskIntoConstraints = false
        authorAddress.numberOfLines = 0
        return authorAddress
    }()
    
    lazy var authorPhone: UILabel = {
        let authorPhone = UILabel()
        authorPhone.text = ""
        authorPhone.translatesAutoresizingMaskIntoConstraints = false
        authorPhone.numberOfLines = 0
        return authorPhone
    }()
    
    lazy var authorWebsite: UILabel = {
        let authorWebsite = UILabel()
        authorWebsite.text = ""
        authorWebsite.translatesAutoresizingMaskIntoConstraints = false
        authorWebsite.numberOfLines = 0
        return authorWebsite
    }()
    
    lazy var authorCompanyName: UILabel = {
        let authorCompanyName = UILabel()
        authorCompanyName.text = ""
        authorCompanyName.translatesAutoresizingMaskIntoConstraints = false
        authorCompanyName.numberOfLines = 0
        return authorCompanyName
    }()
    
    lazy var authorCompanyCatchPhrase: UILabel = {
        let authorCompanyCatchPhrase = UILabel()
        authorCompanyCatchPhrase.text = ""
        authorCompanyCatchPhrase.translatesAutoresizingMaskIntoConstraints = false
        authorCompanyCatchPhrase.numberOfLines = 0
        return authorCompanyCatchPhrase
    }()
    
    lazy var commentsButton: CommentsButton = {
        let button = CommentsButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toggleComments), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    @objc private func toggleComments() {
        showComments.toggle()
        commentsButton.isExpanded = showComments
        commentsStack.isHidden.toggle()
        
        if showComments {
            UIView.animate(withDuration: 0.3) {
                let bottomOffset = CGPoint(x: 0, y: self.scrollView.bounds.height - self.scrollView.contentSize.height)
                self.scrollView.setContentOffset(bottomOffset, animated: true)
            }
        } 
    }
    
    lazy var commentsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.isHidden = true
        return stack
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
        
        setUpScrollView()
        setUpAuthorSection()
        setUpSpinner()
        showSpinner()
        Task {
            await fetchPost()
        }
    }
    
    private func setUpScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(stack)
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(postDescriptionLabel)
        stack.addArrangedSubview(authorSection)
        stack.addArrangedSubview(commentsButton)
        stack.addArrangedSubview(commentsStack)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            
            stack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }
    
    private func setUpAuthorSection() {
        authorSection.addSubview(authorStack)
        
        authorStack.addArrangedSubview(authorName)
        authorStack.addArrangedSubview(authorUserName)
        authorStack.addArrangedSubview(authorEmail)
        authorStack.addArrangedSubview(authorAddress)
        authorStack.addArrangedSubview(authorPhone)
        authorStack.addArrangedSubview(authorWebsite)
        authorStack.addArrangedSubview(authorCompanyName)
        authorStack.addArrangedSubview(authorCompanyCatchPhrase)
        
        NSLayoutConstraint.activate([
            authorStack.topAnchor.constraint(equalTo: authorSection.topAnchor, constant: 12),
            authorStack.bottomAnchor.constraint(equalTo: authorSection.bottomAnchor, constant: -12),
            authorStack.leadingAnchor.constraint(equalTo: authorSection.leadingAnchor, constant: 12),
            authorStack.trailingAnchor.constraint(equalTo: authorSection.trailingAnchor, constant: -12)
        ])
    }
    
    private func setUpSpinner() {
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
        
        self.authorName.text = "Name: \(self.viewModel.model.user.name)"
        self.authorUserName.text = "Username: \(self.viewModel.model.user.username)"
        self.authorEmail.text = "Email: \(self.viewModel.model.user.email)"
        self.authorAddress.text = "Address: \(self.viewModel.model.user.street)"
        self.authorPhone.text = "Phone: \(self.viewModel.model.user.phone)"
        self.authorWebsite.text = "Website: \(self.viewModel.model.user.website)"
        self.authorCompanyName.text = "Company name: \(self.viewModel.model.user.companyName)"
        self.authorCompanyCatchPhrase.text = "Company catchphrase: \(self.viewModel.model.user.companyCatchPhrase)"
        
        authorSection.backgroundColor = UIColor.systemGray6
        authorSection.layer.borderColor = UIColor.lightGray.cgColor
        authorSection.layer.borderWidth = 1
        
        commentsButton.isHidden = false
        
        commentsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for comment in viewModel.model.comments {
            let commentView = CommentView(comment: comment)
            commentsStack.addArrangedSubview(commentView)
        }
        
        hideSpinner()
    }
}
