//
//  NoteInfoInteractor.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 06.06.2022.
//

import Foundation

class NoteInfoInteractor: NoteInfoBusinessLogic, NoteInfoDataStore {
    private let presenter: NoteInfoPresenter
    private let worker: NoteInfoWorker
    var note: Note?

    init(presenter: NoteInfoPresenter, worker: NoteInfoWorker) {
        self.presenter = presenter
        self.worker = worker
    }

    func showNoteInfo(request: NoteInfo.ShowNote.Request) {
        let currentNote: Note = note ?? Note(titleText: "", mainText: "", date: Date(), userShareIcon: nil)
        let response = NoteInfo.ShowNote.Response(note: currentNote)
        presenter.presentNoteInfo(response: response)
    }

    func saveNoteInfo(request: NoteInfo.SaveNote.Request) {
        let newNote = Note(
            titleText: request.titleText,
            mainText: request.mainText,
            date: request.date,
            userShareIcon: nil
        )
        note = newNote

        worker.saveNote(note: [newNote])

        let response = NoteInfo.SaveNote.Response()
        presenter.presentSaveNote(response: response)
    }
}
