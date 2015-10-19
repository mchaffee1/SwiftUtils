//
//  SuperStringTests.swift
//  SwiftUtils
//
//  Created by Michael Chaffee on 10/19/15.
//  Copyright © 2015 Michael Chaffee. All rights reserved.
//

import XCTest
@testable import SwiftUtils

class SuperStringTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

  func testLength() {
    let s0 = ""
    XCTAssert(s0.length == 0, String(format: "Length of empty string was %d; should be 0", s0.length))
    let s1 = "1"
    XCTAssert(s1.length == 1, String(format: "Length of string was %d; should be 1", s1.length))
    let sPoop = "💩"
    XCTAssert(sPoop.length == 1, String(format: "length of emoji string was %d; should be 1", sPoop.length))
  }
  
  func testTrim() {
    let testStrings: [(orig: String, trimmed: String)] = [("", ""), ("nospace", "nospace"), (" oneleading", "oneleading"), ("  twoleading", "twoleading"), ("onetrailing ", "onetrailing"), ("twotrailing  ", "twotrailing"), (" oneleadonetrail ", "oneleadonetrail"), ("internal space", "internal space"), (" internal space with leading", "internal space with leading"), ("internal space with trailing ", "internal space with trailing")]
    
    for var test in testStrings {
      test.orig.trim()
      XCTAssert(test.orig == test.trimmed, String(format:"Trimmed value '%@' does not match expected value '%@'", test.orig, test.trimmed))
    }
  }
}
