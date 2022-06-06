//
//  File.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 06.06.2022.
//

import Foundation

class NoteListPresenter: NoteListPresentationLogic {
    weak var viewController: NoteListDisplayLogic?

    func presentUploadNotes(response: NoteList.NoteData.Response) {
        let notes = response.notes.map {
            NoteList.NoteData.ViewModel.DisplayedNote(
                titleText: $0.titleText,
                mainText: $0.mainText,
                date: $0.date,
                userShareIcon: $0.userShareIcon
            )
        }
        let viewModel = NoteList.NoteData.ViewModel(displayedNotes: notes)
        viewController?.displayUploadNotes(viewModel: viewModel)
    }

    func presentLocalNotes(response: NoteList.NoteData.Response) {
        let notes = response.notes.map {
            NoteList.NoteData.ViewModel.DisplayedNote(
                titleText: $0.titleText,
                mainText: $0.mainText,
                date: $0.date,
                userShareIcon: $0.userShareIcon
            )
        }
        let viewModel = NoteList.NoteData.ViewModel(displayedNotes: notes)
        viewController?.displayLocalNotes(viewModel: viewModel)
    }
}
