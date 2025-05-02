//
//  ViewController.swift
//  PostsApp
//
//  Created by Juan Camilo Mendieta Hernández on 19/04/25.
//

import UIKit

    final class PostsViewController: UIViewController {
        private let viewModel: PostsViewModelProtocol
        
        private lazy var tableView: UITableView = {
            let tableView = UITableView()
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.dataSource = self
            tableView.delegate = self
            return tableView
        }()

        init(viewModel: PostsViewModelProtocol) {
            self.viewModel = viewModel
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            title = "Posts"
            setupTableView()
            Task {
                await fetchPosts()
            }
        }
        
        @MainActor
        private func fetchPosts() async {
            await viewModel.fetchPosts()
            self.tableView.reloadData()
        }
        
        private func setupTableView() {
            view.addSubview(tableView)
            
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }

//MARK: - TableView protocols
//FIXME: - Manage data type of userId in another component
extension PostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.coordinator?.navigateToPostDetails(postId: String(viewModel.model.posts[indexPath.row].id), postUserId: String(viewModel.model.posts[indexPath.row].userId))
    }
}

extension PostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.model.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        var content = cell.defaultContentConfiguration()
        content.text = viewModel.model.posts[indexPath.row].title
        cell.contentConfiguration = content
        
        return cell
    }
}

