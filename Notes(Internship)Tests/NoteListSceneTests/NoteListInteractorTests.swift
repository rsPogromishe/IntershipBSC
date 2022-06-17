//
//  NoteListInteractorTests.swift
//  Notes(Internship)Tests
//
//  Created by Снытин Ростислав on 15.06.2022.
//

@testable import Notes_Internship_
import XCTest

final class NoteListInteractorTests: XCTestCase {
    var sut: NoteListBusinessLogic!
    var presenter: NoteListPresenterMock!
    var worker: NoteListWorkerMock!

    override func setUp() {
        super.setUp()
        presenter = NoteListPresenterMock()
        worker = NoteListWorkerMock()
        sut = NoteListInteractor(presenter: presenter, worker: worker)
    }

    override func tearDown() {
        sut = nil
        presenter = nil
        worker = nil
        super.tearDown()
    }

    func testGetLocalNotes() {
        let request = NoteList.NoteData.Request()
        sut.getLocalNotes(request: request)
        XCTAssert(worker.getLocalNotesWasCalled, "Не вызван метод Воркера по загрузке данных из UserDefaults")
        XCTAssert(presenter.presentNotesWasCalled, "Не вызван метод воркера по сохранению заметок")
    }

    func testGetFetchedNotes() {
        let request = NoteList.NoteData.Request()
        let expectation = expectation(description: "async test")

        presenter.fetchResponse = {
            XCTAssert(self.presenter.presentNotesWasCalled, "Не вызван метод презентера, при загрузке данных")
            expectation.fulfill()
        }
        sut.getFetchedNotes(request: request)
        wait(for: [expectation], timeout: 0.5)
    }

    func testDeleteLocalNotes() {
        let request = NoteList.DeleteNote.Request(note: [TestData.displayNote])
        sut.deleteLocalNotes(request: request)
        XCTAssert(worker.saveLocalNotesWasCalled, "Не вызван метод воркера по сохранению заметок")
        XCTAssert(presenter.presentDeleteLocalNotesWasCalled, "Не вызван метод презентера по удалению заметок")
    }

    func testDeleteTapNotes() {
        let request = NoteList.DeleteNote.Request(note: [TestData.displayNote])
        sut.deleteTapNotes(request: request)
        XCTAssert(worker.saveLocalNotesWasCalled, "Не вызван метод воркера по сохранению заметок")
    }

    func testShowLoadingView() {
        let request = NoteList.LoadingView.Request()
        sut.showLoadingView(request: request)
        XCTAssert(presenter.presentLoadingViewWasCalled, "Не вызван метод презентера по отображению загрузочной вью")
    }
}
