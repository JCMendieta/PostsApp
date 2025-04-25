//
//  PostDetailsScreenModel.swift
//  PostsApp
//
//  Created by Juan Camilo Mendieta Hernández on 24/04/25.
//

import Foundation

struct PostDetailsScreenModel {
    var post: Post = Post()
    var user: User = User()
    var comments: [Comment] = []
}
