//
//  NoteInfoRouter.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 06.06.2022.
//

import Foundation

class NoteInfoRouter: NoteInfoRoutingLogic, NoteInfoDataPassing {
    weak var viewController: NoteInfoViewController?
    var dataStore: NoteInfoDataStore

    init(dataStore: NoteInfoDataStore) {
        self.dataStore = dataStore
    }

    func routeToNoteList() {
        let noteListVC = NoteListAssembly.build()
        guard var noteListDataStore = noteListVC.router?.dataStore else { return }
        passDataToNoteList(source: dataStore, destination: &noteListDataStore)
    }

    func passDataToNoteList(source: NoteInfoDataStore, destination: inout NoteListDataStore) {
        guard let note = source.note else { return }
        destination.notes.append(note)
    }
}
