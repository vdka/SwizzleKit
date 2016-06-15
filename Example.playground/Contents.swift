
import Foundation
import SwizzleKit

class Foo: Swizzleable {
  
  dynamic func hello() {
    print("Hello World")
  }
  
  dynamic class func thanks(_ name: String) -> String {
    return "Thank you \(name.capitalized)"
  }
}

let foo = Foo()

foo.hello() // prints: Hello World

Foo.replace(instanceMethod: #selector(Foo.hello), withClosure: { print("Hello Swizzling") })

foo.hello() // prints: Hello Swizzling

Foo.thanks("Swift") // returns: Thank you Swift

let block: AnyObject = {
  
  let block: @convention(block) (NSString) -> String = { "\($0), this ones thanks to you" }
  return unsafeBitCast(block, to: AnyObject.self)
}()

Foo.replace(classMethod: #selector(Foo.thanks(_:)), withBlock: block)

Foo.thanks("Dynamic dispatch") // returns: __lldb_expr_7.Foo, this ones thanks to you"
