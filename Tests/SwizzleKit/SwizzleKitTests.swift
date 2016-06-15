import XCTest

@testable import SwizzleKit

class Foo: Swizzleable {
  
  dynamic func bar() -> String { return "old" }
  dynamic class func baz() -> String { return "old" }
}

class SwizzleKitTests: XCTestCase {

  let block: AnyObject = {
    
    let block: @convention(block) () -> String = { return "new" }
    return unsafeBitCast(block, to: AnyObject.self)
  }()
  
  func testInstanceSwizzle() {
    
    Foo.replace(classMethod: #selector(Foo.bar), withBlock: self)
    
    let foo = Foo()
    XCTAssertEqual(foo.bar(), "new")
  }
  
  func testClassSwizzle() {
    
    Foo.replace(classMethod: #selector(Foo.baz), withBlock: self)
    
    XCTAssertEqual(Foo.baz(), "new")
  }
  
  static var allTests : [(String, (SwizzleKitTests) -> () throws -> Void)] {
    return [
      ("testInstanceSwizzle", testInstanceSwizzle),
      ("testClassSwizzle", testClassSwizzle),
    ]
  }
}
