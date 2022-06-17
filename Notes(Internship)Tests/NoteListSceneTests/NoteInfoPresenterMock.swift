//
//  NoteInfoPresenterMock.swift
//  Notes(Internship)Tests
//
//  Created by Снытин Ростислав on 15.06.2022.
//

import Foundation
@testable import Notes_Internship_

final class NoteInfoPresenterMock: NoteInfoPresentationLogic {
    var presentNoteInfoWasCalled = false
    var presentSaveNoteWasCalled = false
    var responseInfoMock: NoteInfo.ShowNote.Response!
    var responseSaveMock: NoteInfo.SaveNote.Response!

    func presentNoteInfo(response: NoteInfo.ShowNote.Response) {
        presentNoteInfoWasCalled = true
        responseInfoMock = response
    }

    func presentSaveNote(response: NoteInfo.SaveNote.Response) {
        presentSaveNoteWasCalled = true
        responseSaveMock = response
    }
}
