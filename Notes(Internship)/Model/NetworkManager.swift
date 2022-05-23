//
//  NetworkManager.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 19.05.2022.
//

import UIKit

class NetworkManager {
    func fetchData(onCompletion: @escaping (([Note]) -> Void), onError: @escaping ((Error) -> Void)) {
        guard let url = createURLcomponents() else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            do {
                if let data = data {
                    if let note = try self.parseJSON(withData: data) {
                        onCompletion(note)
                    }
                }
            } catch let error {
                onError(error)
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

    private func parseJSON(withData data: Data) throws -> [Note]? {
        let decoder = JSONDecoder()
        let noteData = try decoder.decode([Note].self, from: data)
        return noteData
    }
}
