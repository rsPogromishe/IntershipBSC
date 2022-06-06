//
//  NoteListProtocols.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 06.06.2022.
//

import UIKit

protocol NoteListPresentationLogic {
    func presentUploadNotes(response: NoteList.NoteData.Response)
    func presentLocalNotes(response: NoteList.NoteData.Response)
    func presentDeletedLocalNotes(response: NoteList.DeleteNote.Response)
}

protocol NoteListBusinessLogic {
    func showUploadNotes(request: NoteList.NoteData.Request)
    func showLocalNotes(request: NoteList.NoteData.Request)
    func deleteLocalNotes(request: NoteList.DeleteNote.Request)
}

protocol NoteListDataStore {
    var notes: [Note] { get set }
}

protocol NoteListDisplayLogic: AnyObject {
    func displayUploadNotes(viewModel: NoteList.NoteData.ViewModel)
    func displayLocalNotes(viewModel: NoteList.NoteData.ViewModel)
}

protocol NoteListRoutingLogic {
    func routeToViewNote()
    func routeToAddNote()
}

protocol NoteListDataPassing {
    var dataStore: NoteListDataStore? { get }
}
