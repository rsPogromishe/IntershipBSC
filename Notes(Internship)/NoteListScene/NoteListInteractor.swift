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
    var notes: [Note]? {
        didSet {
            notes = notes?.sorted(by: { $0.date ?? Date() > $1.date ?? Date() })
        }
    }

    var arrayOfNotes: [Note] = []

    func showLocalNotes(request: NoteList.NoteData.Request) {
        let localNotes = worker.getLocalNotes()
        arrayOfNotes += localNotes
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
                self.arrayOfNotes += uploadNotes
                self.notes = self.arrayOfNotes
            }
        } onError: { error in
            print(error)
        }
    }
}
