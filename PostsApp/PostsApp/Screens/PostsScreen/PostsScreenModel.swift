//
//  PostsScreenModel.swift
//  PostsApp
//
//  Created by Juan Camilo Mendieta Hernández on 20/04/25.
//

import Foundation

struct PostsScreenModel {
    var posts: [Post] = []
    
    var favoritePosts: [Post] {
        posts.filter { $0.isFavorite }
    }
    
    var regularPosts: [Post] {
        posts.filter { !$0.isFavorite }
    }
}
