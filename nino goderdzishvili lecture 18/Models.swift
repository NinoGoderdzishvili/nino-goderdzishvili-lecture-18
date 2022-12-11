//
//  Models.swift
//  nino goderdzishvili lecture 18
//
//  Created by Nino Goderdzishvili on 12/8/22.
//

import Foundation
import UIKit

struct ResponseDataModel: Codable {
    let userPosts: [UserPost]
}

struct UserPost: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

struct PostComment: Codable {
    let postId: Int
    let id: Int
    let name: String
    let email: String
    let body: String
}
