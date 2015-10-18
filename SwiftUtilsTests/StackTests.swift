//
//  StackTests.swift
//  SwiftUtils
//
//  Created by Michael Chaffee on 10/17/15.
//  Copyright © 2015 Michael Chaffee. All rights reserved.
//

import XCTest
@testable import SwiftUtils

class StackTests: XCTestCase {
  
  let ints = [0, 1, 2, 3, 4]
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testInit() {
    _ = Stack<Int>()
  }
  
  func testPushPop() {
    let stack = Stack<Int>()
    for var i in ints {
      stack.push(i)
    }
    
    for var i = ints.count - 1; i >= 0; i-- {
      let testI = stack.pop()
      XCTAssert(testI! == i, String(format: "Popped value %d differs from pushed value %d", testI ?? -42, i))
    }
    
    let testJ = stack.pop()
    XCTAssert(testJ == nil, String(format: "Popped value %d differs from expected value nil", testJ ?? -42))
  }

  // This looks just like testPushPop() except we're trying to throw in a bunch of nils and making sure we get the same results as without.
  func testNilRejection() {
    let stack = Stack<Int>()
    for var i in ints {
      stack.push(i)
      stack.push(nil)
    }
    
    for var i = ints.count - 1; i >= 0; i-- {
      let testI = stack.pop()
      XCTAssert(testI! == i, String(format: "Popped value %d differs from pushed value %d", testI ?? -42, i))
    }
    
    let testJ = stack.pop()
    XCTAssert(testJ == nil, String(format: "Popped value %d differs from expected value nil", testJ ?? -42))
  }
  
  func testInitWithFirst() {
    let item = 4
    let stack = Stack<Int>(withFirstItem: item)
    XCTAssert(stack.count == 1, String(format: "count after init(withFirst:) of %d differs from expected value 1", stack.count))
    let popped = stack.pop()
    XCTAssert(popped == item, String(format: "Popped value %d differs from initialized first value %d", popped ?? -42, item))
  }

  func testCount() {
    let stack = Stack<Int>()
    XCTAssert(stack.count == 0, String(format: "count after init() %d differs from expected value 0", stack.count))
    
    for var i in ints {
      stack.push(i)
    }
    
    XCTAssert(stack.count == ints.count, String(format: "Stack count %d differs from expected count %d", stack.count, ints.count))
  }
  
  func testFirst() {
    let stack = Stack<Int>()
    for var i in ints {
      stack.push(i)
    }
    
    let first = stack.first()
    XCTAssert(first == ints[0], String(format: "first() result %d differs from expected result %d", first ?? -42, ints[0]))
    XCTAssert(stack.count == 0, String(format: "Count after first() result %d differs from expected result 0", stack.count))

  }
  
  func testPeek() {
    let stack = Stack<Int>()
    let a = stack.peek()
    XCTAssert(a == nil, String(format: "peek() on empty stack returned %d instead of nil", a ?? -42))
    
    stack.push(42)
    let b = stack.peek()
    XCTAssert(b == 42, String(format: "peek() returned %d instead of expected value 42", b ?? -42))
    XCTAssert(stack.count == 1, String(format: "Count after peek() returned %d instead of 1", stack.count))
  }
}


