//
//  SuperDate.swift
//  SwiftUtils
//
//  Created by Michael Chaffee on 10/17/15.
//  Copyright © 2015 Michael Chaffee. All rights reserved.
//

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
  
}

//MARK: - NSCalendar extensions
extension NSCalendar {
}