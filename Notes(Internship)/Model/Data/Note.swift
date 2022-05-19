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
    }
}
