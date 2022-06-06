//
//  NoteInfoInteractor.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 06.06.2022.
//

import Foundation

class NoteInfoInteractor: NoteInfoBusinessLogic, NoteInfoDataStore {
    var presenter: NoteInfoPresenter?
    var worker = NoteInfoWorker()
    var note: Note?

    func showNoteInfo(request: NoteInfo.ShowNote.Request) {
        var currentNote: Note

        if let note = self.note {
            currentNote = note
        } else {
            currentNote = Note(titleText: "", mainText: "", date: Date(), userShareIcon: nil)
            self.note = currentNote
        }
        let response = NoteInfo.ShowNote.Response(note: currentNote)
        presenter?.presentNoteInfo(response: response)
    }

    func saveNoteInfo(request: NoteInfo.SaveNote.Request) {
        guard var note = note else { return }
        note.titleText = request.titleText
        note.mainText = request.mainText
        note.date = request.date

        worker.saveNote(note: note)

        let response = NoteInfo.SaveNote.Response()
        presenter?.presentSaveNote(response: response)
    }
}
