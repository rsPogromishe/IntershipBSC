//
//  File.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 12.06.2022.
//

import UIKit

class NoteInfoAssembly {
    static func build() -> NoteInfoViewController {
        let presenter = NoteInfoPresenter()
        let worker = NoteInfoWorker()
        let interactor = NoteInfoInteractor(presenter: presenter, worker: worker)
        let router = NoteInfoRouter(dataStore: interactor)
        let viewController = NoteInfoViewController(interactor: interactor)

        presenter.viewController = viewController
        router.viewController = viewController
        viewController.router = router

        return viewController
    }
}
