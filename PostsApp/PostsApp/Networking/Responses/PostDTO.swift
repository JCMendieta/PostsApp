//
//  PostResponse.swift
//  PostsApp
//
//  Created by Juan Camilo Mendieta Hernández on 20/04/25.
//

import Foundation

struct PostDTO: Decodable {
    let userId, id: Int
    let title, body: String
}
