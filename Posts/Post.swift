//
//  Post.swift
//  Posts
//
//

import Foundation

public struct Post: Codable, Equatable, Identifiable {
    let body: String
    public let id: Int
    let title: String
    let userID: Int
    
    enum CodingKeys: String, CodingKey {
        case body
        case id
        case title
        case userID = "userId"
    }
}

extension Post {
    static let preview: [Self] = [
        .init(body: "Body 1", id: 1, title: "Title 1", userID: 1),
        .init(body: "Body 2", id: 2, title: "Title 2", userID: 2),
        .init(body: "Body 3", id: 3, title: "Title 3", userID: 3)
    ]
}
