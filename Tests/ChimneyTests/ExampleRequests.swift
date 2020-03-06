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

public enum GetTodosRequestable: Requestable {
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
