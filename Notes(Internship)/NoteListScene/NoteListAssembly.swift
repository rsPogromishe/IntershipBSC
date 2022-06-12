//
//  NoteListAssembly.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 11.06.2022.
//

import UIKit

class NoteListAssembly {
    static func build() -> NoteListViewController {
        let presenter = NoteListPresenter()
        let worker = NoteListWorker()
        let interactor = NoteListInteractor(presenter: presenter, worker: worker)
        let router = NoteListRouter(dataStore: interactor)
        let viewController = NoteListViewController(interactor: interactor)

        presenter.viewController = viewController
        router.viewController = viewController
        viewController.router = router

        return viewController
    }
}
