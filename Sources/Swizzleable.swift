//
//  Swizzleable.swift
//  SwizzleKit
//
//  Created by Ethan Jackwitz on 6/15/16.
//
//

import Foundation
import ObjectiveC.objc_runtime

/// Conformants to Swizzleable with `dynamic` functions may have thier switched at runtime.
/// This is done using the static methods given to conformants of this protocol.
public protocol Swizzleable: class {}

extension Swizzleable {
  
  public static func replace(instanceMethod: Selector, withBlock block: AnyObject) {
    
    let method = class_getInstanceMethod(Self.self, instanceMethod)
    let implementation = imp_implementationWithBlock(block)
    
    method_setImplementation(method, implementation)
  }
  
  public static func replace(classMethod: Selector, withBlock block: AnyObject) {
    
    let method = class_getClassMethod(Self.self, classMethod)
    let implementation = imp_implementationWithBlock(block)
    
    method_setImplementation(method, implementation)
  }
  
  public static func replace(instanceMethod: Selector, withClosure closure: () -> ()) {
    
    replace(instanceMethod: instanceMethod, withBlock: blockify(closure))
  }
  
  public static func replace(classMethod: Selector, withClosure closure: () -> ()) {
    
    replace(classMethod: classMethod, withBlock: blockify(closure))
  }
}

internal func blockify(_ closure: () -> ()) -> AnyObject {
  
  let block: @convention(block) () -> () = closure
  
  return unsafeBitCast(block, to: AnyObject.self)
}
