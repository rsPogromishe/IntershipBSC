//
//  NoteListPresenterTests.swift
//  Notes(Internship)Tests
//
//  Created by Снытин Ростислав on 15.06.2022.
//

@testable import Notes_Internship_
import XCTest

final class NoteListPresenterTests: XCTestCase {
    var sut: NoteListPresenter!
    var viewController: NoteListViewControllerMock!

    override func setUp() {
        super.setUp()
        sut = NoteListPresenter()
        viewController = NoteListViewControllerMock()
        sut.viewController = viewController
    }

    override func tearDown() {
        sut = nil
        viewController = nil
        super.tearDown()
    }

    func testPresentNotes() {
        let response = NoteList.NoteData.Response(notes: [TestData.note])
        sut.presentNotes(response: response)
        XCTAssert(viewController.displayNotesWasCalled, "Не вызван метод контроллера для отображения данных")
    }

    func testPresentDeleteLocalNotes() {
        let response = NoteList.DeleteNote.Response(notes: [TestData.note])
        sut.presentDeletedLocalNotes(response: response)
        XCTAssert(viewController.displayNotesWasCalled, "Не вызван метод контроллера для отображения данных")
    }

    func testDisplayLoadingView() {
        let response = NoteList.LoadingView.Response()
        sut.presentLoadingView(response: response)
        XCTAssert(viewController.displayLoaderWasCalled, "Не вызван метод контроллера для отображения загрузочной вью")
    }
}
