//
//  ServicesManager.swift
//  PostsApp
//
//  Created by Juan Camilo Mendieta Hernández on 20/04/25.
//

import Foundation

protocol ServicesManagerProtocol {
    func request<T: Decodable>(_ url: URL, entity: T.Type) async throws -> T
}

final class ServicesManager: ServicesManagerProtocol {
    let apiClient: APIClientProtocol
    let dataDecoder: DataDecoderProtocol
    
    init(apiClient: APIClientProtocol, dataDecoder: DataDecoderProtocol) {
        self.apiClient = apiClient
        self.dataDecoder = dataDecoder
    }
    
    func request<T>(_ url: URL, entity: T.Type) async throws -> T where T : Decodable {
        do {
            let data = try await apiClient.fetch(from: url)
            let entity = try dataDecoder.decode(T.self, from: data)
            return entity
        } catch {
            throw error
        }
    }
}
