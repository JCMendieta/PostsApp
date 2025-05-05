//
//  UserDTO.swift
//  PostsApp
//
//  Created by Juan Camilo Mendieta Hernández on 24/04/25.
//

import Foundation

//MARK: - UserDTO
struct UserDTO: Decodable {
    let id: Int
    let name, username, email: String
    let address: Address
    let phone, website: String
    let company: Company
}

// MARK: - Address
struct Address: Decodable {
    let street, suite, city, zipcode: String
    let geo: Geo
}

// MARK: - Geo
struct Geo: Decodable {
    let lat, lng: String
}

// MARK: - Company
struct Company: Decodable {
    let name, catchPhrase, bs: String
}

