//
//  NoteInfoProtocols.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 06.06.2022.
//

protocol NoteInfoPresentationLogic {
    func presentNoteInfo(response: NoteInfo.ShowNote.Response)
    func presentSaveNote(response: NoteInfo.SaveNote.Response)
}

protocol NoteInfoRoutingLogic {
    func routeToNoteList()
}

protocol NoteInfoDataPassing {
    var dataStore: NoteInfoDataStore { get }
}

protocol NoteInfoDisplayLogic: AnyObject {
    func displayNoteInfo(viewModel: NoteInfo.ShowNote.ViewModel)
    func displaySaveNote(viewModel: NoteInfo.SaveNote.ViewModel)
}

protocol NoteInfoBusinessLogic {
    func showNoteInfo(request: NoteInfo.ShowNote.Request)
    func saveNoteInfo(request: NoteInfo.SaveNote.Request)
}

protocol NoteInfoDataStore {
    var note: Note? { get set }
}

protocol NoteInfoWorkerLogic {
    func saveNote(note: [Note])
}
