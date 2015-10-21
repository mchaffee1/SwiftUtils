//
//  SuperString.swift
//  SwiftUtils
//
//  Created by Michael Chaffee on 10/19/15.
//  Copyright © 2015 Michael Chaffee. All rights reserved.
//

/*
SuperString gives extensions to the String class for greater fluency.
*/
import Foundation

public extension String {
  // simple length property.
  // Note that this is EXPENSIVE and shouldn't be used injudiciously.
  public var length: Int { get { return self.characters.count } }
  
  
  // Wrapper of String.substringToIndex that takes a nice simple Int
  // and handles invalid indices sensibly.
  public func substringToIndex(index: Int) -> String {
    if index < 1 { return "" }
    if index >= self.length { return self }
    else {
      return self.substringToIndex(self.startIndex.advancedBy(index))
    }
  }

  // Wrapper of String.substringFromIndex that takes a nice simple Int
  // and handles invalid indices sensibly.
  public func substringFromIndex(index: Int) -> String {
    if index < 1 { return self }
    if index >= self.length { return "" }
    
    return self.substringFromIndex(self.startIndex.advancedBy(index))
  }
  
  // Trim leading and trailing spaces.
  public mutating func trim() {
    let space: Character = " "  // the character to trim
    self.trim(space)
  }
  
  // Trim leading and trailing characters
  public mutating func trim(trimChar: Character) {
    var start: String.Index!  // Will hold index of first non-space character, if any
    var end: String.Index!  // Will hold index of last non-space character, if any
    for index in self.characters.indices {
      if self[index] != trimChar {

        // Assign start to the first non-space index we find.
        if start == nil { start = index }

        // Assign end to the last non-space index we find.
        end = index
      }
    }
    // if either start or end is unassigned, then that means there were no non-space characters.
    if start == nil || end == nil {
      self = ""
    } else {
      // There were non-space characters.  Return the substring of that range.
      self = self.substringWithRange(Range<Index>(start: start, end: end.successor()))
    }
  }

}
