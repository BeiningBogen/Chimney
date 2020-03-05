
### Chimney

A convenient way of doing structured web requests


# Usage


### Setting basic auth & base URL
```swift
let configuration =  Configuration.init(basicHTTPAuth: BasicHTTPAuth.init(username: "bogen", password: "hei123")
let baseURL = URL.init(string: "https://beiningbogen.no")!
Chimney.environment = .init(configuration: configuration, baseURL: baseURL)

```

## Defining requests
Follow the protocol Requestable. 

```swift

/// Doing a POST to /users/[userEmail] with no body and blank Response

public enum UserRequest: Requestable {
    public typealias Parameter = Never
    public typealias Response = Void
    
    public static let method: HTTPMethod = .post
    
    public struct Path: PathComponentsProvider {
        public typealias Query = Never
       
        public let userEmail: String
        
        public init(userEmail: String) {
          
            self.userEmail = userEmail
        }
        
        public var pathComponents: (path: [String], query: Query?) {
            return (
                ["notifications", userEmail],
                nil
            )
        }
    }
}
```
