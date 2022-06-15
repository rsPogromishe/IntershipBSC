//
//  NoteListProtocols.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 06.06.2022.
//

protocol NoteListPresentationLogic {
    func presentNotes(response: NoteList.NoteData.Response)
    func presentDeletedLocalNotes(response: NoteList.DeleteNote.Response)
    func presentLoadingView(response: NoteList.LoadingView.Response)
}

protocol NoteListBusinessLogic {
    func getFetchedNotes(request: NoteList.NoteData.Request)
    func getLocalNotes(request: NoteList.NoteData.Request)
    func deleteLocalNotes(request: NoteList.DeleteNote.Request)
    func deleteTapNotes(request: NoteList.DeleteNote.Request)
    func showLoadingView(request: NoteList.LoadingView.Request)
}

protocol NoteListDataStore {
    var notes: [Note] { get set }
    var localNotes: [Note] { get set }
}

protocol NoteListDisplayLogic: AnyObject {
    func displayNotes(viewModel: NoteList.NoteData.ViewModel)
    func displayLoaderView()
}

protocol NoteListRoutingLogic {
    func routeToViewNote()
    func routeToAddNote()
}

protocol NoteListDataPassing {
    var dataStore: NoteListDataStore { get }
}

protocol NoteListWorkerLogic {
    func getLocalNotes() -> [Note]
    func saveLocalNotes(notes: [Note])
    func fetchData(onCompletion: @escaping (([Note]) -> Void), onError: @escaping ((NetworkError) -> Void))
}
