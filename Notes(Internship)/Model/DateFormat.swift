//
//  DateFormat.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 03.04.2022.
//

import Foundation

class DateFormat {
    static func dateToday(day: Date, formatter: String) -> String {
        let format = DateFormatter()
        format.dateFormat = formatter
        format.locale = Locale(identifier: "ru_RU")
        return format.string(from: day)
    }
}
