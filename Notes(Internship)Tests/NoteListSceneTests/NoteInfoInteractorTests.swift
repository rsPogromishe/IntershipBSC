//
//  NoteInfoInteractorTests.swift
//  Notes(Internship)Tests
//
//  Created by Снытин Ростислав on 15.06.2022.
//

@testable import Notes_Internship_
import XCTest

final class NoteInfoInteractorTests: XCTestCase {
    var sut: NoteInfoBusinessLogic!
    var presenter: NoteInfoPresenterMock!
    var worker: NoteInfoWorkerMock!

    override func setUp() {
        super.setUp()
        presenter = NoteInfoPresenterMock()
        worker = NoteInfoWorkerMock()
        sut = NoteInfoInteractor(presenter: presenter, worker: worker)
    }

    override func tearDown() {
        sut = nil
        presenter = nil
        worker = nil
        super.tearDown()
    }

    func testShowNoteInfo() {
        let request = NoteInfo.ShowNote.Request()
        sut.showNoteInfo(request: request)
        XCTAssert(presenter.presentNoteInfoWasCalled, "Не вызван метод презентера для отображения данных")
    }

    func testSaveNoteInfo() {
        let request = TestData.saveNoteInfo
        sut.saveNoteInfo(request: request)
        XCTAssert(worker.saveNoteWasCalled, "Не вызван метод воркера для сохранения данных")
        XCTAssert(presenter.presentSaveNoteWasCalled, "Не вызван метод презентера для сохранения данных")
    }
}
