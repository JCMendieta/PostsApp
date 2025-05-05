//
//  User.swift
//  PostsApp
//
//  Created by Juan Camilo Mendieta Hernández on 24/04/25.
//

import Foundation

struct User {
    let id: Int
    let name, username, email: String
    let street, suite, city, zipCode: String
    let addressLat, addressLng: String
    let phone, website: String
    let companyName, companyCatchPhrase, companyBs: String
    
    init() {
        self.id = 0
        self.name = ""
        self.username = ""
        self.email = ""
        self.street = ""
        self.suite = ""
        self.city = ""
        self.zipCode = ""
        self.addressLat = ""
        self.addressLng = ""
        self.phone = ""
        self.website = ""
        self.companyName = ""
        self.companyCatchPhrase = ""
        self.companyBs = ""
    }
    
    init(from dto: UserDTO) {
        self.id = dto.id
        self.name = dto.name
        self.username = dto.username
        self.email = dto.email
        self.street = dto.address.street
        self.suite = dto.address.suite
        self.city = dto.address.city
        self.zipCode = dto.address.zipcode
        self.addressLat = dto.address.geo.lat
        self.addressLng = dto.address.geo.lng
        self.phone = dto.phone
        self.website = dto.website
        self.companyName = dto.company.name
        self.companyCatchPhrase = dto.company.catchPhrase
        self.companyBs = dto.company.bs
    }
}
