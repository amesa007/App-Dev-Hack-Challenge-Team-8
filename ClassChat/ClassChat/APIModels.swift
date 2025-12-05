//
//  APIModels.swift
//  ClassChat
//
//  Created by Gabriel Xu on 12/5/25.
//

import Foundation

struct APIUser: Codable {
    let id: Int
    let name: String
}

struct APIGroup: Codable {
    let id: Int
    let title: String
    let description: String
}

struct APIPost: Codable {
    let id: Int
    let content: String
    let user: APIUser
    let group: APIGroup
}

struct APIPostsResponse: Codable {
    let post: [APIPost]
}

struct APIGroupsResponse: Codable {
    let groups: [APIGroup]
}
