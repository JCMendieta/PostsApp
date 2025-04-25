//
//  CommentDTO.swift
//  PostsApp
//
//  Created by Juan Camilo Mendieta Hernández on 24/04/25.
//

import Foundation

// MARK: - CommentDTO
struct CommentDTO: Codable {
    let postId, id: Int
    let name, email, body: String
}
