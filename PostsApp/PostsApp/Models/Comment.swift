//
//  Comment.swift
//  PostsApp
//
//  Created by Juan Camilo Mendieta Hernández on 24/04/25.
//

import Foundation

struct Comment {
    let postId, id: Int
    let name, email, body: String
    
    init(from dto: CommentDTO) {
        postId = dto.postId
        id = dto.id
        name = dto.name
        email = dto.email
        body = dto.body
    }
}
