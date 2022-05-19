//
//  DateExtensions.swift
//  CarbCount
//
//  Created by SH Developer on 19.05.2022.
//

import Foundation

public extension Calendar {
    static func localizedCalendar(_ locale: String, timezoneAbbreviation: String) -> Calendar {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: locale)
        calendar.timeZone = TimeZone(abbreviation:timezoneAbbreviation)!
        return calendar
    }

    static func defaultLocalizedCalendar() -> Calendar {
        return localizedCalendar("tr_TR", timezoneAbbreviation: "MSD")
    }
}
