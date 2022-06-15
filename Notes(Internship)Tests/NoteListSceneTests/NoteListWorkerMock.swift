//
//  NoteListWorkerTests.swift
//  Notes(Internship)Tests
//
//  Created by Снытин Ростислав on 15.06.2022.
//

import Foundation
@testable import Notes_Internship_

final class NoteListWorkerMock: NoteListWorkerLogic {
    var getLocalNotesWasCalled = false
    var saveLocalNotesWasCalled = false
    var fetchDataWasCalled = false
    var fetchDataResponse = [TestData.note]

    func getLocalNotes() -> [Note] {
        getLocalNotesWasCalled = true
        return [Note]()
    }

    func saveLocalNotes(notes: [Note]) {
        saveLocalNotesWasCalled = true
    }

    func fetchData(onCompletion: @escaping (([Note]) -> Void), onError: @escaping ((NetworkError) -> Void)) {
        fetchDataWasCalled = true
        onCompletion(fetchDataResponse)
    }
}
