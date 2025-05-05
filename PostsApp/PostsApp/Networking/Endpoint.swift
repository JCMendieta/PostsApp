//
//  Endpoint.swift
//  PostsApp
//
//  Created by Juan Camilo Mendieta Hernández on 20/04/25.
//

import Foundation

enum Endpoint {
    case posts
    case post(postId: String)
    case postComments(postId: String)
    case user(userId: String)
    
    var urlString: String {
        switch self {
        case .posts:
            return "posts"
        case .post(let postId):
            return "posts/\(postId)"
        case .postComments:
            return "comments"
        case .user(let userId):
            return "users/\(userId)"
        }
    }
    
    func asURL() throws -> URL {
        let baseURL = "https://jsonplaceholder.typicode.com"
        guard let url = URL(string: baseURL + "/\(urlString)") else { throw URLError(.badURL) }
        
        switch self {
        case .posts:
            return url
        case .post:
            return url
        case .postComments(let postId):
            let postIdQuery = URLQueryItem(name: "postId", value: postId)
            return url.appending(queryItems: [postIdQuery])
        case .user:
            return url
        }
    }
}
