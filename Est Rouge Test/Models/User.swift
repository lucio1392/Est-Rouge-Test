//
//  User.swift
//  Est Rouge Test
//
//  Created by Lucio on 5/4/19.
//  Copyright © 2019 Lucio. All rights reserved.
//

import Foundation
import CoreData

struct User: Codable {

    var name: String
    var id: Int
    var avatar: String
    var htmlUrl: String
    var location: String?
    var bio: String?
    var publicRepos: Int?
    var followers: Int?
    var following: Int?

    enum CodingKeys: String, CodingKey {
        case name = "login"
        case id
        case avatar = "avatar_url"
        case htmlUrl = "html_url"
        case bio
        case location
        case publicRepos = "public_repos"
        case followers
        case following
    }


}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

extension User {
    static func user() -> User {
        return User(name: "Mocking User",
                    id: 1,
                    avatar: "",
                    htmlUrl: "",
                    location: nil,
                    bio: nil,
                    publicRepos: nil,
                    followers: nil,
                    following: nil)
    }
}
