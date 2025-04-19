//
//  Coordinator.swift
//  PostsApp
//
//  Created by Juan Camilo Mendieta Hernández on 19/04/25.
//

import UIKit

protocol CoordinatorProtocol {
    var navigationController: UINavigationController { get set }
    
    func navigateToStartScreen()
}

final class Coordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigateToStartScreen() {
        navigationController.pushViewController(ViewController(), animated: true)
    }
}
