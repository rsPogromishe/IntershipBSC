//
//  NoteInfoModels.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 06.06.2022.
//

import Foundation

enum NoteInfo {
    enum ShowNote {
        struct Request {
        }

        struct Response {
            let note: Note
        }

        struct ViewModel {
            var titleText: String
            var mainText: String
            var date: Date?
        }
    }
    enum SaveNote {
        struct Request {
            let titleText: String
            let mainText: String
            let date: Date?
        }

        struct Response {
        }

        struct ViewModel {
        }
    }
}
