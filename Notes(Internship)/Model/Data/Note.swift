//
//  Note.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 03.04.2022.
//

import Foundation

struct Note: Codable {
    var titleText: String
    var mainText: String
    var date: Date?
    var userShareIcon: String?
    var isEmpty: Bool {
        if mainText.isEmpty {
            return true
        } else {
            return false
        }
    }

    enum CodingKeys: String, CodingKey {
        case titleText = "header"
        case mainText = "text"
        case date = "date"
        case userShareIcon = "userShareIcon"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateToDecode = try container.decode(Int.self, forKey: .date)
        date = Date(timeIntervalSince1970: TimeInterval(dateToDecode))
        titleText = try container.decode(String.self, forKey: .titleText)
        mainText = try container.decode(String.self, forKey: .mainText)
        userShareIcon = try container.decodeIfPresent(String.self, forKey: .userShareIcon)
    }

    init(titleText: String, mainText: String, date: Date?, userShareIcon: String?) {
        self.mainText = mainText
        self.titleText = titleText
        self.date = date
        self.userShareIcon = userShareIcon
    }
}
