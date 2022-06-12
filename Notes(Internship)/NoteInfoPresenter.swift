//
//  NoteInfoPresenter.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 06.06.2022.
//

class NoteInfoPresenter: NoteInfoPresentationLogic {
    weak var viewController: NoteInfoDisplayLogic?

    func presentNoteInfo(response: NoteInfo.ShowNote.Response) {
        let titleText = response.note.titleText
        let mainText = response.note.mainText
        let date = response.note.date

        let viewModel = NoteInfo.ShowNote.ViewModel(
            titleText: titleText,
            mainText: mainText,
            date: date
        )

        viewController?.displayNoteInfo(viewModel: viewModel)
    }

    func presentSaveNote(response: NoteInfo.SaveNote.Response) {
        let viewModel = NoteInfo.SaveNote.ViewModel()
        viewController?.displaySaveNote(viewModel: viewModel)
    }
}
