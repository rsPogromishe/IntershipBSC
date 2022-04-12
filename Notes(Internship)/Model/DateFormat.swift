//
//  DateFormat.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 03.04.2022.
//

import Foundation
import UIKit

class DateFormat {
    static func dateToday(day: Date, formatter: String) -> String {
        let format = DateFormatter()
        format.dateFormat = formatter
        format.locale = Locale(identifier: "ru_RU")
        return format.string(from: day)
    }

    static func changeDateTextField(sender: UIDatePicker) -> String {
        let format = DateFormatter()
        format.dateFormat = "dd MMMM YYYY"
        return format.string(from: sender.date)
    }
}
