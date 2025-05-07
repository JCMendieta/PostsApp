//
//  ViewController.swift
//  PostsApp
//
//  Created by Juan Camilo Mendieta Hernández on 19/04/25.
//

import UIKit

enum PostsScreenSection {
    case favorites
    case regular
}

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
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = indexPath.section == 0
        ? viewModel.model.favoritePosts[indexPath.row]
        : viewModel.model.regularPosts[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.coordinator?.navigateToPostDetails(postId: String(post.id), postUserId: String(post.userId))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfPosts(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.reuseIdentifier, for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()
        }
        let post: Post
        switch viewModel.sections[indexPath.section] {
        case .favorites:
            post = viewModel.model.favoritePosts[indexPath.row]
        case .regular:
            post = viewModel.model.regularPosts[indexPath.row]
        }
        
        cell.configure(with: post)
        cell.onStarTapped = { [weak self] in
            self?.viewModel.toggleFavorite(for: post.id)
            self?.tableView.reloadData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch viewModel.sections[section] {
        case .favorites:
            return "Favorite Posts"
        case .regular:
            return "All Posts"
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            
            let oldSections = self.viewModel.sections
            self.viewModel.deletePost(at: indexPath)
            let newSections = self.viewModel.sections
            
            tableView.performBatchUpdates {
                if oldSections != newSections {
                    // The number of sections has changed (likely removed .favorites)
                    tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
                } else {
                    // Just remove the row
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
    
            completionHandler(true)
        }
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

