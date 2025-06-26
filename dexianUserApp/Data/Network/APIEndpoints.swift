//
//  APIEndpoints.swift
//  dexianUser
//
//  Created by sheik hanifa on 26/06/25.
//

struct APIEndpoints {
    
    struct Users {
        static let list = "/users"
        static let create = "/users"
        static func detail(id: Int) -> String { "/users/\(id)" }
        static func update(id: Int) -> String { "/users/\(id)" }
        static func delete(id: Int) -> String { "/users/\(id)" }
    }
    
    struct Posts {
        static func userPosts(userId: Int) -> String { "/users/\(userId)/posts" }
        static func create(userId: Int) -> String { "/users/\(userId)/posts" }
    }
    
    struct Comments {
        static func postComments(postId: Int) -> String { "/posts/\(postId)/comments" }
        static func create(postId: Int) -> String { "/posts/\(postId)/comments" }
    }
    
    struct Todos {
        static func userTodos(userId: Int) -> String { "/users/\(userId)/todos" }
        static func create(userId: Int) -> String { "/users/\(userId)/todos" }
    }
}

