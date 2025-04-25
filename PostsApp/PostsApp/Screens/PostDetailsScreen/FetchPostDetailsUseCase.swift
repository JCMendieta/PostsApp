//
//  FetchPostDetailsUseCase.swift
//  PostsApp
//
//  Created by Juan Camilo Mendieta Hernández on 24/04/25.
//

import Foundation

protocol FetchPostDetailsUseCaseProtocol {
    func fetchPostDetails(postId: String) async throws -> PostDTO
    func fetchUser(userId: String) async throws -> UserDTO
    func fetchPostComments(postId: String) async throws -> [CommentDTO]
}

final class FetchPostDetailsUseCase: FetchPostDetailsUseCaseProtocol {
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchPostDetails(postId: String) async throws -> PostDTO {
        do {
            let results = try await repository.fetchPost(postId: postId)
            return results
        } catch {
            throw error
        }
    }
    
    func fetchUser(userId: String) async throws -> UserDTO {
        do {
            let results = try await repository.fetchUser(userId: userId)
            return results
        } catch {
            throw error
        }
    }
    
    func fetchPostComments(postId: String) async throws -> [CommentDTO] {
        do {
            let results = try await repository.fetchPostComments(postId: postId)
            return results
        } catch {
            throw error
        }
    }
}
