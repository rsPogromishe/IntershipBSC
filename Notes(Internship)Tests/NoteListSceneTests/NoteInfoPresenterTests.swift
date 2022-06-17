//
//  NoteInfoPresenterTests.swift
//  Notes(Internship)Tests
//
//  Created by Снытин Ростислав on 15.06.2022.
//

@testable import Notes_Internship_
import XCTest

final class NoteInfoPresenterTests: XCTestCase {
    var sut: NoteInfoPresenter!
    var viewController: NoteInfoViewControllerMock!

    override func setUp() {
        super.setUp()
        sut = NoteInfoPresenter()
        viewController = NoteInfoViewControllerMock()
        sut.viewController = viewController
    }

    override func tearDown() {
        sut = nil
        viewController = nil
        super.tearDown()
    }

    func testPresentNoteInfo() {
        let response = NoteInfo.ShowNote.Response(note: TestData.note)
        sut.presentNoteInfo(response: response)
        XCTAssert(viewController.displayNoteInfoWasCalled, "Не вызван метод контроллера для отображения данных")
    }

    func testPresentSaveNote() {
        let response = NoteInfo.SaveNote.Response()
        sut.presentSaveNote(response: response)
        XCTAssert(viewController.displaySaveNoteWasCalled, "Не вызван метод контроллера для сохранения данных")
    }
}
