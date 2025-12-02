//
//  Post.swift
//  ClassChat
//
//  Created by Angelina Lu on 12/1/25.
//

import Foundation
//represents a post
struct Post {
    let id: Int
    let author: String
    let message: String
    let hashtag: String
    var likeCount: Int
    var isLikedByMe: Bool
}
