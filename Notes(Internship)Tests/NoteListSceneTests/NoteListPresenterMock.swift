//
//  NoteListPresenterMock.swift
//  Notes(Internship)Tests
//
//  Created by Снытин Ростислав on 15.06.2022.
//

import Foundation
@testable import Notes_Internship_

final class NoteListPresenterMock: NoteListPresentationLogic {
    var presentNotesWasCalled = false
    var presentDeleteLocalNotesWasCalled = false
    var presentLoadingViewWasCalled = false
    var responseMock: NoteList.NoteData.Response!
    var responseDeleteMock: NoteList.DeleteNote.Response!
    var fetchResponse: (() -> Void)?

    func presentNotes(response: NoteList.NoteData.Response) {
        presentNotesWasCalled = true
        responseMock = response
        fetchResponse?()
    }

    func presentDeletedLocalNotes(response: NoteList.DeleteNote.Response) {
        presentDeleteLocalNotesWasCalled = true
        responseDeleteMock = response
    }

    func presentLoadingView(response: NoteList.LoadingView.Response) {
        presentLoadingViewWasCalled = true
    }
}
