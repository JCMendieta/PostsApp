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
            tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.reuseIdentifier)
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
extension PostsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = indexPath.section == 0
        ? viewModel.model.favoritePosts[indexPath.row]
        : viewModel.model.regularPosts[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.coordinator?.navigateToPostDetails(postId: String(post.id), postUserId: String(post.userId))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0
        ? viewModel.model.favoritePosts.count
        : viewModel.model.regularPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.reuseIdentifier, for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()
        }
        
        let post = indexPath.section == 0
        ? viewModel.model.favoritePosts[indexPath.row]
        : viewModel.model.regularPosts[indexPath.row]
        
        cell.configure(with: post)
        cell.onStarTapped = { [weak self] in
            self?.viewModel.toggleFavorite(for: post.id)
            self?.tableView.reloadData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "Favorites" : "All Posts"
    }
}

