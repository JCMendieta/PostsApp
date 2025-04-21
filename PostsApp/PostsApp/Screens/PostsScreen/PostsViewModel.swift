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
    
    func fetchPosts() async
    func mapToPostsModel(from postsDTO: [PostDTO]) -> [Post]
}

final class PostsViewModel: PostsViewModelProtocol {
    weak var coordinator: CoordinatorProtocol?
    var useCase: any FetchPostsUseCaseProtocol
    var model = PostsScreenModel()
    
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
}
