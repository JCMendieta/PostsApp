//
//  Repository.swift
//  PostsApp
//
//  Created by Juan Camilo Mendieta Hernández on 20/04/25.
//

import Foundation

protocol RepositoryProtocol {
    func fetchPosts() async throws -> [PostDTO]
    func fetchPost(postId: String) async throws -> PostDTO
    func fetchPostComments(postId: String) async throws -> [CommentDTO]
    func fetchUser(userId: String) async throws -> UserDTO
}

final class Repository: RepositoryProtocol {
    private let servicesManager: ServicesManagerProtocol
    
    init(servicesManager: ServicesManagerProtocol = ServicesManager(apiClient: URLSessionAPIClientWrapper(), dataDecoder: JSONDecoderWrapper())) {
        self.servicesManager = servicesManager
    }
    
    func fetchPosts() async throws -> [PostDTO] {
        guard let apiURL = try? Endpoint.posts.asURL() else {
            throw URLError(.badURL)
        }
        
        do {
            return try await servicesManager.request(apiURL, entity: [PostDTO].self)
        } catch {
            throw error
        }
    }
    
    func fetchPost(postId: String) async throws -> PostDTO {
        guard let apiURL = try? Endpoint.post(postId: postId).asURL() else {
            throw URLError(.badURL)
        }
        
        do {
            return try await servicesManager.request(apiURL, entity: PostDTO.self)
        }
    }
    
    func fetchPostComments(postId: String) async throws -> [CommentDTO] {
        guard let apiURL = try? Endpoint.postComments(postId: postId).asURL() else {
            throw URLError(.badURL)
        }
        
        do {
            return try await servicesManager.request(apiURL, entity: [CommentDTO].self)
        }
    }
    
    func fetchUser(userId: String) async throws -> UserDTO {
        guard let apiURL = try? Endpoint.user(userId: userId).asURL() else {
            throw URLError(.badURL)
        }
        
        do {
            return try await servicesManager.request(apiURL, entity: UserDTO.self)
        }
    }
}
