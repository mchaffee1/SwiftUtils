//
//  Stack.swift
//  SwiftUtils
//
//  Created by Michael Chaffee on 10/17/15.
//  Copyright © 2015 Michael Chaffee. All rights reserved.
//

// Simple Stack implementation.  Item and Stack impl both in this file.
import Foundation

public class StackItem<T> {
  internal var value: T
  internal var prior: StackItem!
  
  init(withItem: T) {
    self.value = withItem
  }
}

public class Stack<T> {
  private var head: StackItem<T>!
  private var _count = 0

  public init() { }
  
  // "convenience" init when we know what the first item in the stack is at time of creation.
  public convenience init(withFirstItem: T?) {
    self.init()
    self.push(withFirstItem)
  }
  
  // Classic stack push.
  public func push(item: T?) {
    // Don't accept nil's on my stack.
    if item == nil { return }
    
    let newItem = StackItem(withItem: item!)
    newItem.prior = head
    head = newItem
    _count++
  }
  
  // Classic stack pop.  Note that the work is done by helper function popStackItem()
  public func pop() -> T? {
    if let stackItem = popStackItem() {
      return stackItem.value
    } else {
      return nil
    }
  }

  // Empty the stack and return the first value that was ever pushed.  This was created to support
  // an "undo all" operation.
  public func first() -> T? {
    if head == nil { return nil }
    
    var result = head
    while result.prior != nil {
      result = popStackItem()
    }
    
    return result.value
  }
  
  // Number of items in the stack.
  public var count: Int { get { return _count } }
  
  // Stack pop operation returns the StackItem object rather than the value.  At creation time,
  // this is in order to support the first() operation.
  private func popStackItem() -> StackItem<T>? {
    if head == nil { return nil }
    _count--
    let result = head
    if result != nil {
      head = result.prior
    } else {
      head = nil
    }
    return result
  }

}
