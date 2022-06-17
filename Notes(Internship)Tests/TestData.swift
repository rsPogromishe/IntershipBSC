//
//  TestData.swift
//  Notes(Internship)Tests
//
//  Created by Снытин Ростислав on 15.06.2022.
//

import Foundation
@testable import Notes_Internship_

struct TestData {
    static let note = Note(
        titleText: "TestTitle",
        mainText: "TestMainText",
        date: Date(),
        userShareIcon: nil
    )

    static let displayNote = NoteList.NoteData.ViewModel.DisplayedNote(
        titleText: "TestTitle",
        mainText: "TestMainText",
        date: Date(),
        userShareIcon: nil
    )

    static let saveNoteInfo = NoteInfo.SaveNote.Request(
        titleText: "TestTitle",
        mainText: "TestMainText",
        date: Date()
    )
}
