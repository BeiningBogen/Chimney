import XCTest
@testable import Chimney

final class ChimneyTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Chimney.environment = Environment.init(configuration: Configuration.init(authentication: nil, baseURL: URL.init(string: "https://jsonplaceholder.typicode.com")!))
        
    }
    
    func testSimpleGetRequest() {
        let exp = expectation(description: "do a simple GET request")
        let wantedResult = Todo.init(id: 1, userId: 1, title: "delectus aut autem", completed: false)
        
        GetTodosRequestable.request(path: GetTodosRequestable.Path.init(index: 1)) { result in
            switch result {
                case .failure(let error):
                    XCTFail(error.debugDescription)
                case .success(let success):
                    XCTAssertEqual(success, wantedResult)
            }
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testWrongPathTimeout() {
        let exp = expectation(description: "do a DELETE request that should time out")
        GetWrongPathTodosRequestable.request(path: .init(index: 1)) { result in
            switch result {
                case .failure(let error):
                    if case .statusCode(let code, _, _ ) = error {
                        XCTAssertEqual(code, 404)
                    } else {
                        XCTFail("Wrong error type")
                    }
                    break
                case .success(_):
                    XCTFail("The web server should not support DELETE.")
            }
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 31, handler: nil)
    }
    
    func testGetRequestWithBaseURLInPathComponents() {
        let exp = expectation(description: "do a simple GET request")
        let wantedResult = Todo.init(id: 1, userId: 1, title: "delectus aut autem", completed: false)
        /// Sets the "wrong baseURL" so we can test that this is not used
        Chimney.environment = Environment.init(configuration: Configuration.init(authentication: nil, baseURL: URL.init(string: "https://notAWorkingDomain.no")!))
        
        GetTodosWithBaseURLInPathRequestable.request(path: .init(index: 1)) { result in
            switch result {
                case .failure(let error):
                    XCTFail(error.debugDescription)
                case .success(let success):
                    XCTAssertEqual(success, wantedResult)
            }
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testBearerAuthentication() {
        Chimney.environment = Environment.init(
            configuration: Configuration.init(
                authentication: BearerAuth(token: "grrbrr"),
                baseURL: URL.init(string: "https://jsonplaceholder.typicode.com")!
            )
        )
        let exp = expectation(description: "do a simple GET request")
        let wantedResult = Todo.init(id: 1, userId: 1, title: "delectus aut autem", completed: false)

        GetTodosRequestable.request(path: GetTodosRequestable.Path.init(index: 1)) { result in
            switch result {
                case .failure(let error):
                    XCTFail(error.debugDescription)
                case .success(let success):
                    XCTAssertEqual(success, wantedResult)
            }
            exp.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func testOtherApiType() {
        let exp = expectation(description: "do a simple GET request")
        let wantedResult = Todo.init(id: 1, userId: 1, title: "delectus aut autem", completed: false)
        /// Sets the "wrong baseURL" so we can test that this is not used
        Chimney.environment = Environment.init(configuration: Configuration.init(
            authentication: BearerAuth(token: "grrbrr"),
            baseURL: URL.init(string: "https://notAWorkingDomain.no")!)
        )

        GetTodosWithBaseURLInPathRequestable2.request(path: .init(index: 1)) { result in
            switch result {
                case .failure(let error):
                    XCTAssert(error.debugDescription.contains("Code=-1002"))
                case .success(let success):
                    XCTAssertEqual(success, wantedResult)
            }
            exp.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    static var allTests = [
        ("testGetRequestWithBaseURLInPathComponents", testGetRequestWithBaseURLInPathComponents),
        ("testSimpleGetRequest", testSimpleGetRequest),
        ("testWrongPathTimeout", testWrongPathTimeout),
        ("testBearerAuthentication", testBearerAuthentication),
        ("testOtherApiType", testOtherApiType)
    ]
    
}
