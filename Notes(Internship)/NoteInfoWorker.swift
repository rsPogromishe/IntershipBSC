//
//  NoteInfoWorker.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 06.06.2022.
//

import Foundation

class NoteInfoWorker: NoteInfoWorkerLogic {
    func saveNote(note: [Note]) {
        NoteStorage().appendNote(note)
    }
}
