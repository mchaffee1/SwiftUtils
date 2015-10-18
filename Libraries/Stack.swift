//
//  Stack.swift
//  SwiftUtils
//
//  Created by Michael Chaffee on 10/17/15.
//  Copyright © 2015 Michael Chaffee. All rights reserved.
//

// Simple Stack with a couple tiny twists.  Stack and Item impl both in this file.
import Foundation

//MARK: - Stack class
public class Stack<T> {
  
  //MARK: - Private members
  private var head: StackItem<T>!
  private var _count = 0

  // MARK: - Initializers
  public init() { }
  
  // "convenience" init when we know what the first item in the stack is at time of creation.
  public convenience init(withFirstItem: T?) {
    self.init()
    self.push(withFirstItem)
  }
  
  // MARK: - Public methods
  
  // Classic stack push.
  public func push(item: T?) {
    // Don't accept nil's on my stack.
    if item == nil { return }
    
    let newItem = StackItem(withItem: item!)
    newItem.prior = head
    head = newItem
    _count++
  }
  
  // Classic stack pop.  Note that the work is done by helper function popStackItem() which is also used by first()
  public func pop() -> T? {
    if let stackItem = popStackItem() {
      return stackItem.value
    } else {
      return nil
    }
  }

  // Inspect the item at the top of the stack, without popping it.
  public func peek() -> T? {
    return head?.value
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
  
  //MARK: - Private methods
  
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

//MARK: - StackItem class
public class StackItem<T> {
  internal var value: T
  internal var prior: StackItem!
  
  init(withItem: T) {
    self.value = withItem
  }
}

