//
//  NetworkManager.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 19.05.2022.
//

import UIKit

enum Response {
    case onSuccess(note: [Note])
    case onError(error: Error)
}

class NetworkManager {
<<<<<<< Updated upstream
    var onCompletion: ((Response) -> Void)?

    func fetchQuote() {
=======
    func fetchData(onCompletion: @escaping ((Response) -> Void)) {
>>>>>>> Stashed changes
        guard let url = createURLcomponents() else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                if let note = self.parseJSON(withData: data) {
<<<<<<< Updated upstream
                    self.onCompletion?(.onSuccess(note: note))
                }
            } else if let error = error {
                self.onCompletion?(.onError(error: error))
=======
                    onCompletion(.onSuccess(note: note))
                }
            } else if let error = error {
                onCompletion(.onError(error: error))
>>>>>>> Stashed changes
            }
        }.resume()
    }

    private func createURLcomponents() -> URL? {
        var urlComponents = URLComponents()

        urlComponents.scheme = "https"
        urlComponents.host = "firebasestorage.googleapis.com"
        urlComponents.path = "/v0/b/ios-test-ce687.appspot.com/o/Empty.json"
        urlComponents.queryItems = [
            URLQueryItem(name: "alt", value: "media"),
            URLQueryItem(name: "token", value: "d07f7d4a-141e-4ac5-a2d2-cc936d4e6f18")
        ]
        return urlComponents.url
    }

    private func parseJSON(withData data: Data) -> [Note]? {
        let decoder = JSONDecoder()
        do {
            let noteData = try decoder.decode([Note].self, from: data)
            return noteData
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
}
