//
//  ExampleRequests.swift
//  ChimneyTests
//
//  Created by Håkon Bogen on 06/03/2020,10.
//

import Foundation
@testable import Chimney

public struct Todo: Codable, Equatable {
    let id: Int
    let userId: Int
    let title: String
    let completed: Bool
}

public struct ApiType1: APIType {
    public var url = "omg.lol.grr"
    public var authentication: Authentication? = BearerAuth(token: "lol")
}

public struct ApiType2: APIType {
    public var url = "lol.omg.grr"
    public var authentication: Authentication? = BasicHTTPAuth(username: "omg", password: "lol")
}

public enum GetTodosRequestable: Requestable {
    public static var apiType: APIType? = nil

    public typealias Parameter = Never
    public typealias Response = Todo
    
    public static let method: HTTPMethod = .get
    
    public struct Path: PathComponentsProvider {
        public typealias Query = Never
       
        public let index: Int
        
        public init(index: Int) {
          
            self.index = index
        }
        
        public var pathComponents: (path: [String], query: Query?) {
            return (
                ["todos", "\(self.index)"],
                nil
            )
        }
    }
}

/// This is an example request that is in a test that does not support Http keyword DELETE
public enum GetWrongPathTodosRequestable: Requestable {
    public static var apiType: APIType? = nil
    public typealias Parameter = Never
    public typealias Response = Todo
    
    public static let method: HTTPMethod = .get
    
    public struct Path: PathComponentsProvider {
        public typealias Query = Never
       
        public let index: Int
        
        public init(index: Int) {
          
            self.index = index
        }
        
        public var pathComponents: (path: [String], query: Query?) {
            return (
                ["todos", "wrongPath", "\(self.index)"],
                nil
            )
        }
    }
}


public enum GetTodosWithBaseURLInPathRequestable: Requestable {
    public static var apiType: APIType? = nil
    public typealias Parameter = Never
    public typealias Response = Todo
    
    public static let method: HTTPMethod = .get
    
    public struct Path: PathComponentsProvider {
        public typealias Query = Never
       
        public let index: Int
        
        public init(index: Int) {
          
            self.index = index
        }
        
        public var pathComponents: (path: [String], query: Query?) {
            return (
                ["https://jsonplaceholder.typicode.com","todos", "\(self.index)"],
                nil
            )
        }
    }
}

public enum GetTodosWithBaseURLInPathRequestable2: Requestable {
    public static var apiType: APIType? = ApiType1()
    public typealias Parameter = Never
    public typealias Response = Todo

    public static let method: HTTPMethod = .get

    public struct Path: PathComponentsProvider {
        public typealias Query = Never

        public let index: Int

        public init(index: Int) {

            self.index = index
        }

        public var pathComponents: (path: [String], query: Query?) {
            return (
                ["https://jsonplaceholder.typicode.com","todos", "\(self.index)"],
                nil
            )
        }
    }
}
