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
    
    lazy var titleLabel: UILabel = makeLabel()
    lazy var postDescriptionLabel: UILabel = makeLabel(fontSize: 12, numberOfLines: 10)
    
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
    
    lazy var authorName: UILabel = makeLabel()
    lazy var authorUserName: UILabel = makeLabel()
    lazy var authorEmail: UILabel = makeLabel()
    lazy var authorAddress: UILabel = makeLabel()
    lazy var authorPhone: UILabel = makeLabel()
    lazy var authorWebsite: UILabel = makeLabel()
    lazy var authorCompanyName: UILabel = makeLabel()
    lazy var authorCompanyCatchPhrase: UILabel = makeLabel()
    
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
    
    private func makeLabel(fontSize: CGFloat = 17, numberOfLines: Int = 0, text: String = "") -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = numberOfLines
        label.font = label.font.withSize(fontSize)
        label.text = text
        
        return label
    }
    
    @MainActor
    private func fetchPost() async {
        await viewModel.fetchPostDetails(postId: postId, userId: userId)
        
        titleLabel.text = "Title: \(self.viewModel.model.post.title)"
        postDescriptionLabel.text = self.viewModel.model.post.body
        
        authorName.text = "Name: \(self.viewModel.model.user.name)"
        authorUserName.text = "Username: \(self.viewModel.model.user.username)"
        authorEmail.text = "Email: \(self.viewModel.model.user.email)"
        authorAddress.text = "Address: \(self.viewModel.model.user.street)"
        authorPhone.text = "Phone: \(self.viewModel.model.user.phone)"
        authorWebsite.text = "Website: \(self.viewModel.model.user.website)"
        authorCompanyName.text = "Company name: \(self.viewModel.model.user.companyName)"
        authorCompanyCatchPhrase.text = "Company catchphrase: \(self.viewModel.model.user.companyCatchPhrase)"
        
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
