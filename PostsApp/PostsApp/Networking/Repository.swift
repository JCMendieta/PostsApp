//
//  Repository.swift
//  PostsApp
//
//  Created by Juan Camilo Mendieta Hernández on 20/04/25.
//

import Foundation

protocol RepositoryProtocol {
    func fetchPosts() async throws -> [PostDTO]
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
}
