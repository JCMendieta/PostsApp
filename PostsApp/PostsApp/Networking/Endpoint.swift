//
//  Endpoint.swift
//  PostsApp
//
//  Created by Juan Camilo Mendieta Hernández on 20/04/25.
//

import Foundation

enum Endpoint {
    case posts
    
    var urlString: String {
        switch self {
        case .posts:
            return "posts"
        }
    }
    
    func asURL() throws -> URL {
        let baseURL = "https://jsonplaceholder.typicode.com"
        guard let url = URL(string: baseURL + "/\(urlString)") else { throw URLError(.badURL) }
        return url
    }
}
