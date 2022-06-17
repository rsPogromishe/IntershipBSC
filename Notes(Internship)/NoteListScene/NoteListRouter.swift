//
//  NoteListRouter.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 06.06.2022.
//

import UIKit

class NoteListRouter: NoteListRoutingLogic, NoteListDataPassing {
    weak var viewController: NoteListViewController?
    var dataStore: NoteListDataStore

    init(dataStore: NoteListDataStore) {
        self.dataStore = dataStore
    }

    func routeToViewNote() {
        let noteInfoVC = NoteInfoAssembly.build()
        guard var noteInfoDataStore = noteInfoVC.router?.dataStore else { return }
        passDataToNoteInfoView(source: dataStore, destination: &noteInfoDataStore)
        if noteInfoDataStore.note != nil {
            if !dataStore.localNotes.contains(where: { note in
                noteInfoDataStore.note?.mainText == note.mainText &&
                noteInfoDataStore.note?.titleText == note.titleText &&
                noteInfoDataStore.note?.date == note.date
            }) {
                noteInfoVC.noteIsInSaved = false
            }
            viewController?.navigationController?.pushViewController(noteInfoVC, animated: true)
        }
    }

    func routeToAddNote() {
        let noteInfoVC = NoteInfoAssembly.build()
        viewController?.navigationController?.pushViewController(noteInfoVC, animated: true)
    }

    func passDataToNoteInfoView(source: NoteListDataStore, destination: inout NoteInfoDataStore) {
        guard let selectedRow = viewController?.tableView.indexPathForSelectedRow?.row else { return }
        destination.note = source.notes[selectedRow]
    }
}
