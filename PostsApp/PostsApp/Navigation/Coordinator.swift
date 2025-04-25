//
//  Coordinator.swift
//  PostsApp
//
//  Created by Juan Camilo Mendieta Hernández on 19/04/25.
//

import UIKit

protocol CoordinatorProtocol: AnyObject {
    var navigationController: UINavigationController { get set }
    
    func navigateToStartScreen()
    func navigateToPostDetails(postId: String, postUserId: String)
}

final class Coordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    private let repository = Repository()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigateToStartScreen() {
        let useCase = FetchPostsUseCase(repository: repository)
        let viewModel = PostsViewModel(coordinator: self, useCase: useCase)
        let viewController = PostsViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func navigateToPostDetails(postId: String, postUserId: String) {
        let useCase = FetchPostDetailsUseCase(repository: repository)
        let viewModel = PostDetailsViewModel(coordinator: self, useCase: useCase)
        let viewController = PostDetailsViewController(viewModel: viewModel, userId: postUserId, postId: postId)
        navigationController.pushViewController(viewController, animated: true)
    }
}
