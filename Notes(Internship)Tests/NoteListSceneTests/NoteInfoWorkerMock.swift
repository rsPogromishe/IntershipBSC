//
//  NoteInfoWorkerMock.swift
//  Notes(Internship)Tests
//
//  Created by Снытин Ростислав on 15.06.2022.
//

import Foundation
@testable import Notes_Internship_

final class NoteInfoWorkerMock: NoteInfoWorkerLogic {
    var saveNoteWasCalled = false

    func saveNote(note: [Note]) {
        saveNoteWasCalled = true
    }
}
