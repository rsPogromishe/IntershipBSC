//
//  NoteListWorker.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 06.06.2022.
//

import UIKit

enum NetworkError: String, Error {
    case failedURL
    case emptyData
    case parsingError
}

class NoteListWorker: NoteListWorkerLogic {
    func getLocalNotes() -> [Note] {
        return NoteStorage().loadNotes()
    }

    func saveLocalNotes(notes: [Note]) {
        NoteStorage().saveNotes(notes)
    }

    func fetchData(onCompletion: @escaping (([Note]) -> Void), onError: @escaping ((NetworkError) -> Void)) {
        guard let url = createURLcomponents() else {
            onError(.failedURL)
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                do {
                    if let note = try self.parseJSON(withData: data) {
                        onCompletion(note)
                    }
                } catch {
                    onError(.parsingError)
                }
            } else {
                onError(.emptyData)
            }
        }.resume()
    }

    private func createURLcomponents() -> URL? {
        var urlComponents = URLComponents()

        urlComponents.scheme = "https"
        urlComponents.host = "firebasestorage.googleapis.com"
        urlComponents.path = "/v0/b/ios-test-ce687.appspot.com/o/lesson8.json"
        urlComponents.queryItems = [
            URLQueryItem(name: "alt", value: "media"),
            URLQueryItem(name: "token", value: "215055df-172d-4b98-95a0-b353caca1424")
        ]
        return urlComponents.url
    }

    private func parseJSON(withData data: Data) throws -> [Note]? {
        let decoder = JSONDecoder()
        let noteData = try decoder.decode([Note].self, from: data)
        return noteData
    }
}
