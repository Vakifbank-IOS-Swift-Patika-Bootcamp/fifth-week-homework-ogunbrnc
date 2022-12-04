//
//  Client.swift
//  BreakingBad
//
//  Created by Ogün Birinci on 23.11.2022.
//

import Foundation

final class Client {
    
    enum Endpoints {
        static let base = "https://www.breakingbadapi.com/api"

        case characters
        case characterQuotes(String)
        case episodes
        
        var stringValue: String {
            switch self {
            case .characters:
                return Endpoints.base + "/characters"
            case .characterQuotes(let characterName):
                let characterNameWithoutSpace = characterName.replacingOccurrences(of: " ", with: "+")
                return Endpoints.base + "/quote?author=\(characterNameWithoutSpace)"
            case .episodes:
                return Endpoints.base + "/episodes?series=Breaking+Bad"
            }
            
        }

        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    @discardableResult
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(BaseResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()

        return task
    }
    
    class func getCharacters(completion: @escaping ([Character]?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.characters.url, responseType: [Character].self) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func getCharacterQuotes(characterName: String,completion: @escaping ([CharacterQuote]?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.characterQuotes(characterName).url, responseType: [CharacterQuote].self) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func getEpisodes(completion: @escaping ([Episode]?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.episodes.url, responseType: [Episode].self) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    
}
