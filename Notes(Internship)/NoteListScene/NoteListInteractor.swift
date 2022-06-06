//
//  NoteListInteractor.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 06.06.2022.
//

import Foundation

class NoteListInteractor: NoteListBusinessLogic, NoteListDataStore {
    var presenter: NoteListPresenter?
    var worker = NoteListWorker()

    var notes: [Note] = [] {
        didSet {
            notes = notes.sorted(by: { $0.date ?? Date() > $1.date ?? Date() })
        }
    }

    var localNotes: [Note] = []

    func showLocalNotes(request: NoteList.NoteData.Request) {
        localNotes = worker.getLocalNotes()
        localNotes.forEach { note in
            notes.removeAll(where: {
                $0.mainText == note.mainText &&
                $0.titleText == note.titleText &&
                $0.date == note.date
            })
        }
        self.notes += localNotes
        let response = NoteList.NoteData.Response(notes: localNotes)
        presenter?.presentLocalNotes(response: response)
    }

    func showUploadNotes(request: NoteList.NoteData.Request) {
        var uploadNotes: [Note] = []
        worker.fetchData { [weak self] uploadNote in
            guard let self = self else { return }
            DispatchQueue.main.async {
                uploadNotes.append(contentsOf: uploadNote)
                let response = NoteList.NoteData.Response(notes: uploadNotes)
                self.presenter?.presentUploadNotes(response: response)
                self.notes += uploadNotes
            }
        } onError: { error in
            print(error)
        }
    }

    func deleteLocalNotes(request: NoteList.DeleteNote.Request) {
        request.note.forEach { note in
            localNotes.removeAll(where: {
                $0.mainText == note.mainText &&
                $0.titleText == note.titleText &&
                $0.date == note.date
            })
            self.notes.removeAll(where: { showNote in
                showNote.mainText == note.mainText &&
                showNote.titleText == note.titleText &&
                showNote.date == note.date
            })
        }
        self.notes += localNotes
        worker.saveLocalNotes(notes: localNotes)
        let response = NoteList.DeleteNote.Response(notes: localNotes)
        presenter?.presentDeletedLocalNotes(response: response)
    }
}
