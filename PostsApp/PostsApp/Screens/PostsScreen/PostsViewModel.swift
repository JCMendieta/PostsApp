//
//  PostsViewModel.swift
//  PostsApp
//
//  Created by Juan Camilo Mendieta Hernández on 20/04/25.
//

import Foundation

protocol PostsViewModelProtocol {
    var coordinator: CoordinatorProtocol? { get }
    var useCase: FetchPostsUseCaseProtocol { get }
    var model: PostsScreenModel { get set }
    var sections: [PostsScreenSection] { get }
    
    func fetchPosts() async
    func mapToPostsModel(from postsDTO: [PostDTO]) -> [Post]
    func toggleFavorite(for postId: Int)
    func deletePost(at indexPath: IndexPath)
    func hasFavorites() -> Bool
    func numberOfPosts(in section: Int) -> Int
    func deleteAllRegularPosts()
}

final class PostsViewModel: PostsViewModelProtocol {
    weak var coordinator: CoordinatorProtocol?
    var useCase: any FetchPostsUseCaseProtocol
    var model = PostsScreenModel()
    
    var sections: [PostsScreenSection] {
        if model.favoritePosts.isEmpty {
            return [.regular]
        }
        else if model.regularPosts.isEmpty {
            return [.favorites]
        } else {
            return [.favorites, .regular]
        }
    }
    
    init(
        coordinator: CoordinatorProtocol? = nil,
        useCase: any FetchPostsUseCaseProtocol
    ) {
        self.coordinator = coordinator
        self.useCase = useCase
    }
    
    func fetchPosts() async {
        do {
            let data = try await useCase.getPosts()
            model.posts = mapToPostsModel(from: data)
        } catch {
            print(error)
        }
    }
    
    func mapToPostsModel(from postsDTO: [PostDTO]) -> [Post] {
        let posts = postsDTO.map { Post(from: $0) }
        return posts
    }
    
    func toggleFavorite(for postId: Int) {
        if let index = model.posts.firstIndex(where: { $0.id == postId }) {
            model.posts[index].isFavorite.toggle()
        }
    }
    
    func hasFavorites() -> Bool {
        return !model.favoritePosts.isEmpty
    }
    
    func numberOfPosts(in section: Int) -> Int {
        switch sections[section] {
        case .favorites:
            return model.favoritePosts.count
        case .regular:
            return model.regularPosts.count
        }
    }
}

//MARK: - Data management related functions
extension PostsViewModel {
    func deletePost(at indexPath: IndexPath) {
        let postToDelete = getPost(at: indexPath)
        model.posts.removeAll { $0.id == postToDelete.id }
    }
    
    func getPost(at indexPath: IndexPath) -> Post {
        switch sections[indexPath.section] {
        case .favorites:
            return model.favoritePosts[indexPath.row]
        case .regular:
            return model.regularPosts[indexPath.row]
        }
    }
    
    func deleteAllRegularPosts() {
        model.posts.removeAll { !$0.isFavorite }
    }
}
