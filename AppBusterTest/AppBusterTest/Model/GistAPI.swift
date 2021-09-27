//
//  GistAPI.swift
//
//  Pagination
//
//  AppBusterTest
//
//  Created by Денис Денисов on 16.09.2021.
//

import Foundation

private extension URL {
    init?(host: URL, endpointComponents: EndpointComponents) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host.absoluteString
        components.path = endpointComponents.path.reduce("") { "\($0)/\($1)"  }
        components.queryItems = endpointComponents.queryItems
        guard let url = components.url else { return nil }
        self = url
    }
}

private struct IncorrectInputResponse: Decodable {
    let message: String
    let documentationURL: String
    
    enum CodingKeys: String, CodingKey {
        case message
        case documentationURL = "documentation_url"
    }
}

enum APIError: Error {
    case incorrectDataType
    case systemError
    case serverError
    case incorrectInput
}

protocol EndpointComponents {
    var path: [String] { get }
    var queryItems: [URLQueryItem]? { get }
}

struct UserGistsEndpoint: EndpointComponents {
    let username: String
    var path: [String] {
        ["users", username, "gists"]
    }
   
    let gistsPerPage: Int
    let pageNumber: Int
    
    var queryItems: [URLQueryItem]? {
        [
            URLQueryItem(name: "per_page", value: String(gistsPerPage)),
            URLQueryItem(name: "page", value: String(pageNumber))
        ]
    }
    
    init(username: String, gistsPerPage: Int = 6, pageNumber: Int = 0) {
        self.username = username
        self.gistsPerPage = gistsPerPage
        self.pageNumber = pageNumber
    }
}

struct GistAPI {
    private let host = URL(string: "api.github.com")!
    
    enum Endpoints {
        case userGistsEndpoint(associatedValue: UserGistsEndpoint)
        
        var endpointComponents: EndpointComponents {
            switch self {
            case .userGistsEndpoint(let endpointComponents):
                return endpointComponents
            }
        }
    }
    
    func request<Model: Decodable>(
        endpoint: Endpoints,
        completion completionHandler: @escaping (Result<Model, APIError>) -> Void
    ) {
        guard let url = URL(host: host, endpointComponents: endpoint.endpointComponents) else {
            fatalError("Error: your endpoints are not valid")
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completionHandler(.failure(.systemError))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                fatalError("Something is wrong with Foundation API")
            }
            if httpResponse.statusCode == 404 {
                completionHandler(.failure(.incorrectInput))
                return
            } else if !(200...299).contains(httpResponse.statusCode) {
                completionHandler(.failure(.serverError))
                return
            }
            if let data = data,
               let models = try? JSONDecoder().decode(Model.self, from: data) {
                completionHandler(.success(models))
            } else if let data = data,
                      let _ = try? JSONDecoder().decode(IncorrectInputResponse.self, from: data) {
                completionHandler(.failure(.incorrectInput))
            } else {
                completionHandler(.failure(.incorrectDataType))
            }
            
        }
        .resume()
    }
    
}


