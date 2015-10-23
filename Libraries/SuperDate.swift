//
//  SuperDate.swift
//  SwiftUtils
//
//  Created by Michael Chaffee on 10/17/15.
//  Copyright © 2015 Michael Chaffee. All rights reserved.
//

/*
These extensions make NSDate work more fluently.
Importantly, they are all pretty naive:  All work happens in currentCalendar(), etc.
This is good enough for simple apps but care should be exercised for high-precision work.
*/
import Foundation

//MARK: - NSDate extensions
public extension NSDate {
  
  // initialize from Y/M/D
  convenience init(year: Int, month: Int, day: Int) {
    let calendar = NSCalendar.currentCalendar()
    let components = NSDateComponents()
    components.year = year
    components.month = month
    components.day = day
    self.init(timeInterval:0, sinceDate: calendar.dateFromComponents(components)!)
  }
  
  // Short string
  func shortString() -> String {
    return self.toString(dateStyle: .ShortStyle, timeStyle: .NoStyle)
  }
  
  // Describe self in specified style
  func toString(dateStyle dateStyle: NSDateFormatterStyle, timeStyle: NSDateFormatterStyle) -> String {
    return NSDateFormatter.localizedStringFromDate(self, dateStyle: dateStyle, timeStyle: timeStyle)
  }
  
  func toYearMonthDay() -> NSDateComponents {
    return NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: self)
  }
  
}

//MARK: - NSCalendar extensions
extension NSCalendar {
}