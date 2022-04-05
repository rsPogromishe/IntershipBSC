//
//  Note.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 03.04.2022.
//

import Foundation

struct Note {
    var titleText: String?
    var mainText: String?
    var date: String?
    var isEmpty: Bool {
        if titleText?.isEmpty ?? true && mainText?.isEmpty ?? true {
            return true
        } else {
            return false
        }
    }
}
