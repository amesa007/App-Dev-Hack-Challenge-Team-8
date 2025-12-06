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

struct APIGroupSimple: Codable {
    let id: Int
    let title: String
}

struct APIGroup: Codable {
    let id: Int
    let title: String
    let description: String
    let members: [APIUser]
    let posts: [APIPostSimple]
}

struct APIPost: Codable {
    let id: Int
    let content: String
    let user: APIUser
    let group: APIGroupSimple
    let tags: [APITag]
}

struct APIPostSimple: Codable, Identifiable {
    let id: Int
    let content: String
}

struct APITag: Codable, Identifiable {
    let id: Int
    let name: String
}

struct APIPostsResponse: Codable {
    let posts: [APIPost]
}

struct APIGroupsResponse: Codable {
    let groups: [APIGroup]
}
