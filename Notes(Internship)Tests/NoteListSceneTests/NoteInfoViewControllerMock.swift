//
//  NoteInfoViewControllerMock.swift
//  Notes(Internship)Tests
//
//  Created by Снытин Ростислав on 15.06.2022.
//

import Foundation
@testable import Notes_Internship_

final class NoteInfoViewControllerMock: NoteInfoDisplayLogic {
    var displayNoteInfoWasCalled = false
    var displaySaveNoteWasCalled = false
    var viewModel: NoteInfo.ShowNote.ViewModel!
    var saveViewModel: NoteInfo.SaveNote.ViewModel!

    func displayNoteInfo(viewModel: NoteInfo.ShowNote.ViewModel) {
        displayNoteInfoWasCalled = true
        self.viewModel = viewModel
    }

    func displaySaveNote(viewModel: NoteInfo.SaveNote.ViewModel) {
        displaySaveNoteWasCalled = true
        self.saveViewModel = viewModel
    }
}
