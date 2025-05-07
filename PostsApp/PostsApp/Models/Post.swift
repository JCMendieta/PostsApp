//
//  Post.swift
//  PostsApp
//
//  Created by Juan Camilo Mendieta Hernández on 20/04/25.
//

import Foundation

struct Post {
    let userId, id: Int
    let title, body: String
    var isFavorite: Bool = false
    
    init() {
        self.userId = 0
        self.id = 0
        self.title = ""
        self.body = ""
    }
    
    init(from dto: PostDTO) {
        self.userId = dto.userId
        self.id = dto.id
        self.title = dto.title
        self.body = dto.body
    }
}
