//
//  NoteListRouter.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 06.06.2022.
//

import UIKit

class NoteListRouter: NoteListRoutingLogic, NoteListDataPassing {
    weak var viewController: NoteListViewController?
    var dataStore: NoteListDataStore?

    func routeToViewNote() {
        let noteInfoVC = NoteInfoViewController()
        viewController?.navigationController?.pushViewController(noteInfoVC, animated: true)
        guard let dataStore = dataStore else { return }
        guard var noteInfoDataStore = noteInfoVC.router?.dataStore else { return }
        passDataToNoteInfoView(source: dataStore, destination: &noteInfoDataStore)
    }

    func routeToAddNote() {
        let noteInfoVC = NoteInfoViewController()
        viewController?.navigationController?.pushViewController(noteInfoVC, animated: true)
    }

    func passDataToNoteInfoView(source: NoteListDataStore, destination: inout NoteInfoDataStore) {
        guard let selectedRow = viewController?.tableView.indexPathForSelectedRow?.row else { return }
        destination.note = source.notes[selectedRow]
    }
}
