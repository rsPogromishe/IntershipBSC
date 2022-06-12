//
//  File.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 06.06.2022.
//

class NoteListPresenter: NoteListPresentationLogic {
    weak var viewController: NoteListDisplayLogic?

    func presentNotes(response: NoteList.NoteData.Response) {
        let notes = response.notes.map {
            NoteList.NoteData.ViewModel.DisplayedNote(
                titleText: $0.titleText,
                mainText: $0.mainText,
                date: $0.date,
                userShareIcon: $0.userShareIcon
            )
        }
        let viewModel = NoteList.NoteData.ViewModel(displayedNotes: notes)
        viewController?.displayNotes(viewModel: viewModel)
    }

    func presentDeletedLocalNotes(response: NoteList.DeleteNote.Response) {
        let notes = response.notes.map {
            NoteList.NoteData.ViewModel.DisplayedNote(
                titleText: $0.titleText,
                mainText: $0.mainText,
                date: $0.date,
                userShareIcon: $0.userShareIcon
            )
        }
        let viewModel = NoteList.NoteData.ViewModel(displayedNotes: notes)
        viewController?.displayNotes(viewModel: viewModel)
    }

    func presentLoadingView(response: NoteList.LoadingView.Response) {
        viewController?.displayLoaderView()
    }
}
