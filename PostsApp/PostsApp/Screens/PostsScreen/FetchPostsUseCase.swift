//
//  FetchPostsUseCase.swift
//  PostsApp
//
//  Created by Juan Camilo Mendieta Hernández on 20/04/25.
//

import Foundation

protocol FetchPostsUseCaseProtocol {
    func getPosts() async throws -> [PostDTO]
}

final class FetchPostsUseCase: FetchPostsUseCaseProtocol {
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func getPosts() async throws -> [PostDTO] {
        do {
            let results = try await repository.fetchPosts()
            return results
        } catch {
            throw error
        }
    }
}
