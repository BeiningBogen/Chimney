import XCTest
@testable import Chimney

final class ChimneyTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Chimney.environment = Environment.init(configuration: Configuration.init(basicHTTPAuth: nil, baseURL: URL.init(string: "https://jsonplaceholder.typicode.com")!))
        
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

    static var allTests = [
        ("testSimpleGetRequest", testSimpleGetRequest),
    ]
   
}

extension Result where Failure : Error {
    
    var isSuccess: Bool  {
        return false
    }
    

}
