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

I'm throwing a few little EventKit extensions in too...
*/
import Foundation
import EventKit

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
  func toShortString() -> String {
    return self.toString(dateStyle: .ShortStyle, timeStyle: .NoStyle)
  }
  
  // Describe self in specified style
  func toString(dateStyle dateStyle: NSDateFormatterStyle, timeStyle: NSDateFormatterStyle) -> String {
    return NSDateFormatter.localizedStringFromDate(self, dateStyle: dateStyle, timeStyle: timeStyle)
  }
  
  // Return only year/month/day components of current date.
  func toYearMonthDay() -> NSDateComponents {
    return NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: self)
  }
  
}

// MARK: - NSDate: ISO8601 conformance
public extension NSDate {
  private static var iso8601formatter: NSDateFormatter {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)
    formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
    formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    return formatter
  }
  
  // Convert self to an ISO8601 string
  func toISO8601() -> String {
    let formatter = NSDate.iso8601formatter
    return formatter.stringFromDate(self)
  }

  // Initialize from an ISO8601 string
  convenience init(fromISO8601 iso: String) {
    let formatter = NSDate.iso8601formatter
    self.init(timeInterval:0, sinceDate:formatter.dateFromString(iso)!)
  }
}

//MARK: - NSCalendar extensions
public extension NSCalendar {
  // return LOCAL start of first day of month
  func startOfMonth(year year: Int, month: Int) -> NSDate {
    return NSDate(year: year, month: month, day: 1)
  }
  
  // return LOCAL start of first day of month
  func startOfMonth(date: NSDate) -> NSDate {
    let ymd = date.toYearMonthDay()
    return startOfMonth(year: ymd.year, month: ymd.month)
  }
  
  // return LOCAL START of last day of month
  func endOfMonth(year year: Int, month: Int) -> NSDate {
    let comps = NSDateComponents()
    comps.month = 1
    comps.day = -1
    return dateByAddingComponents(comps, toDate: startOfMonth(year: year, month: month), options: [])!
  }
  
  // return LOCAL START of last day of month
  func endOfMonth(date: NSDate) -> NSDate {
    let ymd = date.toYearMonthDay()
    return endOfMonth(year: ymd.year, month: ymd.month)
  }
  
  // Return LOCAL end of day for date.
  // IMPORTANT: This returns the beginning of the last second of the day (23:59:59.000).
  //            Close enough for some things and not for others; make good choices.
  func endOfDayForDate(date: NSDate) -> NSDate {
    let comps = NSDateComponents()
    comps.day = 1
    comps.second = -1
    return dateByAddingComponents(comps, toDate: startOfDayForDate(date), options: [])!
  }
}

//MARK: - EKCalendarItem extensions
public extension EKCalendarItem {
  
  // displayDate gets the best possible date from either an EKEvent or an EKReminder.
  // PLEASE NOTE that this value can actually be nil for an EKReminder.
  var displayDate: NSDate! {
    if let event = self as? EKEvent {
      return event.startDate
    } else if let reminder = self as? EKReminder {
      if let comps = reminder.startDateComponents {
        return NSCalendar.currentCalendar().dateFromComponents(comps)
      }
    }
    return nil
  }
}