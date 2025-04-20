//
//  APIClient.swift
//  PostsApp
//
//  Created by Juan Camilo Mendieta Hernández on 19/04/25.
//

import Foundation

protocol APIClientProtocol {
    func fetch(from url: URL) async throws -> Data
}

final class URLSessionAPIClientWrapper: APIClientProtocol {
    func fetch(from url: URL) async throws -> Data {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            print(error)
            throw error
        }
    }
}
