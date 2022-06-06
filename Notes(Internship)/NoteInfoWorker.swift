//
//  NoteInfoWorker.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 06.06.2022.
//

import Foundation

class NoteInfoWorker {
    func saveNote(note: Note) {
        NoteStorage().saveNotes([note])
    }
}
