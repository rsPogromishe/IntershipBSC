//
//  NoteListViewControllerMock.swift
//  Notes(Internship)Tests
//
//  Created by Снытин Ростислав on 15.06.2022.
//

import Foundation
@testable import Notes_Internship_

final class NoteListViewControllerMock: NoteListDisplayLogic {
    var displayNotesWasCalled = false
    var displayLoaderWasCalled = false
    var viewModel: NoteList.NoteData.ViewModel!

    func displayNotes(viewModel: NoteList.NoteData.ViewModel) {
        displayNotesWasCalled = true
        self.viewModel = viewModel
    }

    func displayLoaderView() {
        displayLoaderWasCalled = true
    }
}
