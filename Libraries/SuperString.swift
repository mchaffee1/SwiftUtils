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

extension String {
  // simple length property.
  // Note that this is EXPENSIVE and shouldn't be used injudiciously.
  public var length: Int { get { return self.characters.count } }
  
  // Trim leading and trailing spaces.
  mutating func trim() {
    let space: Character = " "  // the character to trim
    self.trim(space)
  }
  
  // Trim leading and trailing characters
  mutating func trim(trimChar: Character) {
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
