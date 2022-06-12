//
//  NoteListModels.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 06.06.2022.
//  swiftlint:disable nesting

import Foundation

enum NoteList {
    enum NoteData {
        struct Request {}

        struct Response {
            var notes: [Note]
        }

        struct ViewModel {
            struct DisplayedNote {
                var titleText: String
                var mainText: String
                var date: Date?
                var userShareIcon: String?
            }

            var displayedNotes: [DisplayedNote]
        }
    }

    enum DeleteNote {
        struct Request {
            var note: [NoteList.NoteData.ViewModel.DisplayedNote]
        }

        struct Response {
            var notes: [Note]
        }

        struct ViewModel {}
    }

    enum LoadingView {
        struct Request {}

        struct Response {}

        struct ViewModel {}
    }
}
